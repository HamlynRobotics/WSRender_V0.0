#include <robot.h>

Robot::Robot( std::string &kinematic_file, std::vector<std::string> first_last_link_name,
	      Eigen::Vector3d grav, Eigen::Matrix4d Init_mat)
: m_JPos_lim(2)
, m_JTorque_lim(2)
{
  
  
  m_init_transform = Init_mat;
  
  urdf::Model urdf_model;
  urdf_model.initFile(kinematic_file);
  
  kdl_parser::treeFromUrdfModel (urdf_model, m_robot_tree);
  
  //   m_robot_tree.getChain("world_link", "ee_tip_link", m_robot_chain); //wrt to ee visual
  m_robot_tree.getChain(first_last_link_name[0], first_last_link_name[1], m_robot_chain);
  m_n_joints = m_robot_chain.getNrOfJoints();
  m_n_segs = m_robot_chain.getNrOfSegments();
  
  m_FwdKineSolver = new KDL::ChainFkSolverPos_recursive(m_robot_chain);
  m_JacSolver = new KDL::ChainJntToJacSolver(m_robot_chain);
  
  KDL::Vector grav_kdl;
  tf::vectorEigenToKDL (grav, grav_kdl);
  m_ChainDynParam = new KDL::ChainDynParam(m_robot_chain, grav_kdl);
  m_IdSolver = new KDL::ChainIdSolver_RNE(m_robot_chain, grav_kdl);
}

void Robot::setLims(std::vector<Eigen::VectorXd> JPos_lim, std::vector<Eigen::VectorXd> JTorque_lim)
{
  
  for (int i = 0; i < 2; i++)
  {
    m_JPos_lim[i].resize(m_n_joints);
    m_JTorque_lim[i].resize(m_n_joints);
    
    m_JPos_lim[i] = JPos_lim[i];
    m_JTorque_lim[i] = JTorque_lim[i]; 
  }
}

bool Robot::CheckJointFeasibility(Eigen::VectorXd q)
{
  
  bool res = true;
  
  for (int i = 0; i < m_n_joints; i++)
  {
    if (q(i) < m_JPos_lim[0](i) ||  q(i) > m_JPos_lim[1](i))
    {
      res = false;
    }
  }
  
  return res;
}

bool Robot::FwdKine(Eigen::VectorXd q, Eigen::Matrix4d &Pose)
{
  if (CheckJointFeasibility(q))
  {
    KDL::JntArray q_kdl(m_n_joints);
    
    q_kdl.data = q;
    
    Eigen::Affine3d e;
    KDL::Frame pose;
    
    int kdl_res = m_FwdKineSolver->JntToCart (q_kdl, pose, -1);
    
    tf::transformKDLToEigen (pose ,e );
    
    Pose = m_init_transform*e.matrix();
    
    return true;
  }
  else
  {
    return false; 
  }
  
}

Eigen::Vector3d Robot::getOrient(Eigen::MatrixXd R)
{
  double val = (R(0,0)+R(1,1)+R(2,2)-1)/2.;
  
  val = std::round(val*1000.)/1000.;
  double eps = 1e-03;
  
  double theta = std::acos(val);
  Eigen::Vector3d r;
  
  if (std::abs(std::sin(theta)) > eps)
  {
    r << R(2,1)-R(1,2),
    R(0,2)-R(2,0),
    R(1,0)-R(0,1);
    
    r = 1./(2.*std::sin(theta))*r;
  }
  else //theta = 0, pi
  {
    r.setZero();
    
    if (std::abs(std::cos(theta)-1.)<= eps) //theta = 0  
    {
      
      r(2) = 1.;
      
    }
    
    else
    {
      
      r(0) = std::sqrt((R(0,0)+1)/2.);
      r(1) = std::sqrt((R(1,1)+1)/2.);
      r(2) = std::sqrt((R(2,2)+1)/2.);
      
      if (R(0,1) < 0) { r(0) = -r(0);}
      if (R(2,1) < 0) { r(1) = -r(1);}
      if (r(0)*r(1)*R(0,1) < 0) { r(0) = -r(0);}
      
    }   
  }
  
  return r*theta;
  
}

Eigen::Vector3d Robot::getOrientRPY(Eigen::MatrixXd R)
{
  Eigen::Vector3d orient; //roll, pitch, yaw
  
  orient(1) = std::atan2(-R(2,0), std::sqrt(pow(R(2,1),2)+pow(R(2,2),2)));
  
  double eps = 1e-06;
  
  double c = std::cos(orient(1));
  
  if (std::abs(c) > eps)
  {
    orient(0) = std::atan2(R(2,1),R(2,2));
    orient(2) = std::atan2(R(1,0),R(0,0));
  }
  else
  {
    orient(0) = 0.;
    orient(2) = -std::atan2(R(1,1),R(0,1));
  }
  return orient;
  
}

bool Robot::getJacobian(Eigen::MatrixXd &J, Eigen::VectorXd q)
{
  if (CheckJointFeasibility(q))
  {
    KDL::JntArray q_kdl(m_n_joints);
    
    q_kdl.data = q;
    
    KDL::Jacobian J_kdl(m_n_joints);
    
    int kdl_res = m_JacSolver->JntToJac (q_kdl,J_kdl);
    
    J = J_kdl.data;
    
    return true;
  }
  else 
  {
    return false;
  }
}

std::vector<Eigen::VectorXd> Robot::getWorkspace(int n_samples, std::vector<std::vector<double>> space_bounds, double space_res )
{
  
  //   int n_samples = 51;
  
  Eigen::MatrixXd q(m_n_joints, n_samples); 
  Eigen::MatrixXd x(1,n_samples);
  for (int i = 0; i < n_samples; i++)
  {
    x(0,i) = i;
  }
  
  Eigen::MatrixXd JPos_lim_mat(m_n_joints,1);
  JPos_lim_mat.col(0) = (m_JPos_lim[1]-m_JPos_lim[0])/(n_samples-1.);
  
  q = JPos_lim_mat*x; //each row goes from q_min(i) to q_max(i)
  
  std::vector<Eigen::VectorXd> allVecs(m_n_joints); //set of all vectors to combine.
  
  Eigen::VectorXd lim_min = m_JPos_lim[0];
  
  
  for (int i = 0; i < m_n_joints; i++) 
  {
    Eigen::VectorXd lim(q.cols());
    lim.setOnes();
    lim *= lim_min(i);
    
    allVecs[i] = q.row(i);
    allVecs[i] += lim;
    
  }
  
  Eigen::VectorXd qSoFar(m_n_joints); //combination so far
  std::vector<Eigen::VectorXd> res; //workspace points
  
  //   double d_space = 1e-03;//resolution
  std::vector<double> space_bounds_max;
  space_bounds_max = space_bounds[1];
  //   [3] = {0.8,0.8,0.8}; //1m along x, y ,z
  
  std::vector<double> space_bounds_min = space_bounds[0];
  //   [3] = {-0.8,-0.8,-0.8};
  
  //   int n[3] = {(int) ((space_max[0]-space_bounds_min[0])/d_space), (int) ((space_max[1]-space_bounds_min[1])/d_space), (int) ((space_max[2]-space_bounds_min[2])/d_space)} ;
  
  //number of intervals in each dimension
  int n[3];
  for (int i = 0; i < 3; i++)
  {
    n[i] = (int) ((space_bounds_max[i]-space_bounds_min[i])/space_res);
  }
  
  std::cout<<"n \t"<<n[0]<<" "<<n[1]<<" "<<n[2]<<std::endl;  
  
  boost::multi_array<bool,3> spacematrix(boost::extents[n[0]][n[1]][n[2]]);
  
  
  std::cout<<"Space matrix initialized \t"<<spacematrix[0][0][0]<<std::endl;
  
  
  WS(allVecs,  0,  qSoFar, res, spacematrix, space_bounds_min, space_res);
  
  
  return res;
  
}

void Robot::WS(const std::vector<Eigen::VectorXd>  &allVecs, int vecIndex, Eigen::VectorXd qSoFar,
	       std::vector<Eigen::VectorXd> &res, boost::multi_array<bool,3> &spacematrix, std::vector<double> space_bounds_min, double space_res)
{
  
  if (vecIndex >= allVecs.size())
  {
    
    Eigen::Vector3d P;
    Eigen::VectorXd q_fwdkine(m_n_joints); 
    q_fwdkine = qSoFar;
    
    Eigen::Matrix4d Pose;
    bool res_fwdin =  FwdKine(q_fwdkine,Pose);
    if(res_fwdin)
    {
      
      Eigen::VectorXd dext_Ws; //P,kin dext, dyn dext
      
      P = Pose.block<3,1>(0,3);
      
      Eigen::Vector3d orient = getOrientRPY(Pose.block<3,3>(0,0));
      
      //       Eigen::MatrixXd J;
      //       getJacobian(J,q_fwdkine);
      
      std::vector<double> dext_tmp = DextMeasure(q_fwdkine);
      
      std::vector<double> dext_dyn_tmp = DynamicDextMeasure(q_fwdkine);
      
      double* ptr = &dext_tmp[0];
      Eigen::Map<Eigen::VectorXd> dext(ptr, dext_tmp.size());
      
      ptr = &dext_dyn_tmp[0];
      Eigen::Map<Eigen::VectorXd> dext_dyn(ptr, dext_dyn_tmp.size());
      
      dext_Ws.resize(6+dext.rows()+dext_dyn.rows());
      
      dext_Ws << P,orient,dext,dext_dyn;
      
      int j[3];
      
      for (int k = 0; k < 3; k++)
      {
	
	j[k] = (int) ((P(k)-space_bounds_min[k])/space_res);
	
      }
      
      
      if (spacematrix[j[0]][j[1]][j[2]] == false)
      {
	
	spacematrix[j[0]][j[1]][j[2]] == true;
	
	res.push_back(dext_Ws);
      }
      
      
    }
    
    return;
  }
  
  for (int i=0; i<allVecs[vecIndex].size(); i++)
  {
    qSoFar[vecIndex] = allVecs[vecIndex][i];
    WS(allVecs, vecIndex+1, qSoFar, res, spacematrix, space_bounds_min, space_res);
  }
  return;
}

std::vector<double> Robot::DextMeasure( Eigen::VectorXd q)
{
  std::vector<double> dext(6);
  
  Eigen::MatrixXd J;
  getJacobian(J,q);
  
  Eigen::MatrixXd P(q.rows(),q.rows());
  P.setZero();
  
  for (int i = 0; i < q.rows(); i++)
  {
    double v;
    //     = (2.*q(i)-m_JPos_lim[0](i)-m_JPos_lim[1](i))/(m_JPos_lim[1](i)-m_JPos_lim[0](i));
    v = 1-std::exp(-4.*10.*(m_JPos_lim[1](i)-q(i))*(-m_JPos_lim[0](i)+q(i))/pow((m_JPos_lim[1](i)-m_JPos_lim[0](i)),2));
    
    P(i,i) = v/(1-std::exp(-10.));
  }
  
  J = J*P;
  
  double det = (J*J.transpose()).determinant();
  
  if (det < 0 )
  {
    det = 0.;
    
  }
  
  dext[0] = std::sqrt(det);
  
  Eigen::VectorXd sigma = getSingValues(J);
  
  //Inv cond number
  double eps = 1e-16;
  double max = sigma.maxCoeff() ;
  
  double min = sigma.minCoeff() ;
  if ( std::abs(max) <= eps)
  {
    max = eps;
  }
  
  if ( std::abs(min) <= eps)
  {
    min = eps;
  }
  
  dext[1] = min/max;
  
  //min sing value
  dext[2] = min;
  
  //Order-indep Manipulability
  int n = sigma.rows();
  
  dext[3] = pow(det,1./n);
  
  //Harmonic mean
  double tr = Pinv(J*J.transpose()).trace();
  
  if (std::abs(tr) <= 1e-16)
  {
    tr = 1e-16;
  }
    dext[4] = sqrt(1./tr);
  
  //Isotropic index
  double sigma_mean = sigma.sum()/n;
  dext[5] = pow(det, 1./n);
  
   if (std::abs(sigma_mean) <= 1e-16)
  {
    sigma_mean = 1e-16;
  }
  
  dext[5] = dext[5]/sigma_mean;
  
  
  
  
  return dext;
}

std::vector<double> Robot::DynamicDextMeasure(Eigen::VectorXd q)
{
  std::vector<double> dext(6);
  
  Eigen::MatrixXd B = getInertiaMatrix(q);
  Eigen::MatrixXd L = m_JTorque_lim[1].asDiagonal(); //scaling matrix of torques
  Eigen::MatrixXd J;
  getJacobian(J,q);
  
  Eigen::MatrixXd M1 = B*Pinv(J);
  Eigen::MatrixXd M = Pinv(M1)*L;
  Eigen::MatrixXd H_inv = M1.transpose()*L.inverse()*L.inverse()*M1;
  
  
  Eigen::MatrixXd H = Pinv(H_inv);
  
  //    std::cout<<"eigenvalues inverse length \n"<<M.eigenvalues().transpose()<<std::endl;
  
  double det =  H.determinant();
  if (det < 0 )
  {
    det = 0;
    
  }
  
  dext[0] = std::sqrt(det);
  
  Eigen::VectorXd sigma = getSingValues(M);
  
  //Inv cond number
  double eps = 1e-16;
  double max = sigma.maxCoeff() ;
  
  double min = sigma.minCoeff() ;
  if ( std::abs(max) <= eps)
  {
    max = eps;
  }
  
  if ( std::abs(min) <= eps)
  {
    min = eps;
  }
  
  dext[1] = min/max;
  
  //min sing value
  dext[2] = min;
  
  //Order-indep Manipulability
  int n = sigma.rows();
  
  dext[3] = pow(det,1./n);
  
  //Harmonic mean
  double tr = H_inv.trace();
  
   if (std::abs(tr) <= 1e-16)
  {
    tr = 1e-16;
  }
  
  dext[4] = sqrt(1./tr);
  
  //Isotropic index
  double sigma_mean = sigma.sum()/n;
  dext[5] = pow(det, 1./n);
  
   if (std::abs(sigma_mean) <= 1e-16)
  {
    sigma_mean = 1e-16;
  }
  dext[5] = dext[5]/sigma_mean;
  
  
  return dext;
}


Eigen::MatrixXd Robot::Pinv(Eigen::MatrixXd J)
{
  
  double sigma_thresh;
  
  sigma_thresh = 1e-05;
  
  Eigen::MatrixXd D = Eigen::MatrixXd::Zero(J.cols(),J.rows());
  
  Eigen::JacobiSVD<Eigen::MatrixXd> svd(J, Eigen::ComputeFullU | Eigen::ComputeFullV);
  
  Eigen::MatrixXd U = svd.matrixU();
  Eigen::MatrixXd V = svd.matrixV();
  
  Eigen::MatrixXd S;
  S = U.inverse()*J*V.transpose().inverse();
  
  
  Eigen::VectorXd sigma_vect = S.diagonal();
  
  for (int i = 0; i < sigma_vect.rows(); i++)
  {
    
    if (sigma_vect(i) < sigma_thresh)
    {
      sigma_vect(i) = 0.;
    }
    else
    {
      sigma_vect(i) = 1./sigma_vect(i);
      
    }
    
  }  
  D.diagonal() = sigma_vect;
  
  //   std::cout<<"pinv \n"<<D<<std::endl;
  
  D = V*D*U.transpose();
  
  return D;
}

Eigen::VectorXd Robot::getSingValues(Eigen::MatrixXd J)
{
  
  
  Eigen::MatrixXd D = Eigen::MatrixXd::Zero(J.cols(),J.rows());
  
  Eigen::JacobiSVD<Eigen::MatrixXd> svd(J);
  
  Eigen::VectorXd sigma = svd.singularValues(); 
  
  return sigma;
  
}