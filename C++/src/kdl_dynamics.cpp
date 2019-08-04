#include <robot.h>

Eigen::VectorXd Robot::InverseDyn(Eigen::VectorXd q, Eigen::VectorXd qd, Eigen::VectorXd qdd)
{
  Eigen::VectorXd tau;
  KDL::JntArray q_kdl(m_n_joints), qd_kdl(m_n_joints), qdd_kdl(m_n_joints), tau_kdl(m_n_joints);
  
  q_kdl.data = q.head(m_n_joints);
  qd_kdl.data = qd.head(m_n_joints);
  qdd_kdl.data = qdd.head(m_n_joints);
  
  KDL::Wrenches f_ext(m_n_segs);
  
  for (int i = 0; i < m_n_segs; i++)
  {
    KDL::SetToZero(f_ext[i]); 
  }
  
  m_IdSolver->CartToJnt (q_kdl, qd_kdl, qdd_kdl, f_ext, tau_kdl);
  
  tau = tau_kdl.data;
  return tau; 
  
}

Eigen::MatrixXd Robot::getInertiaMatrix(Eigen::VectorXd q)
{
  KDL::JntArray q_kdl(m_n_joints);
  q_kdl.data = q.head(m_n_joints);
  
  KDL::JntSpaceInertiaMatrix H(m_n_joints);
  m_ChainDynParam->JntToMass (q_kdl, H);
  
  return H.data;
  
}

Eigen::VectorXd Robot::getNonlinear(Eigen::VectorXd q,  Eigen::VectorXd qd)
{
  Eigen::VectorXd nonlin;
  
  KDL::JntArray q_kdl(m_n_joints), qd_kdl(m_n_joints), qdd_kdl(m_n_joints), coriolis(m_n_joints),gravity(m_n_joints);
  
  q_kdl.data = q.head(m_n_joints);
  qd_kdl.data = qd.head(m_n_joints);
  
  m_ChainDynParam->JntToCoriolis (q_kdl, qd_kdl, coriolis);
  m_ChainDynParam->JntToGravity (q_kdl, gravity);
  
  nonlin = coriolis.data+gravity.data;
  
  return nonlin;
}
