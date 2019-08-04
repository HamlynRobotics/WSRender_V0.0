#ifndef ROBOT_HH
#define ROBOT_HH

#include <tuple>
#include <memory>

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <ctime>
#include <chrono>
#include <cmath>

#include <signal.h>

#include <boost/multi_array.hpp>

#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/LU>
#include <map>

#include <thread>
#include <limits>

#include <eigen_conversions/eigen_kdl.h>
#include <kdl_parser/kdl_parser.hpp>
#include <urdf/model.h>
#include <kdl/chainiksolvervel_pinv.hpp>
#include <kdl/chain.hpp>
#include <kdl/chainfksolverpos_recursive.hpp>
#include <kdl/frames_io.hpp>
#include <kdl/chainjnttojacsolver.hpp>
#include <kdl/chainidsolver_recursive_newton_euler.hpp>
#include <kdl/chaindynparam.hpp>
#include <kdl/jntspaceinertiamatrix.hpp>


class Robot
{
  
public:
  
  Robot()
  {
    
  }
  /**
   * @brief: constructor. Reads the URDF file creating a chain from the firat link to the last link.
   * @param first_last_link_name = names of the first and last links of the chain
   * @param grav = gravity vector in refrence frames
   * @param Init_mat = inital transformation matrix
   */
  Robot( std::string &kinematic_file,  std::vector<std::string> first_last_link_name,
	 Eigen::Vector3d grav, Eigen::Matrix4d Init_mat = Eigen::MatrixXd::Identity(4,4));
  /**
   * @brief : function for setting joint position and torque limits
   * @param JPos_lim = array of minimum and maximum position limits
   * @param JTorque_lim = array of minimum and maximum torque limits 
   */
  void setLims(std::vector<Eigen::VectorXd> JPos_lim, std::vector<Eigen::VectorXd> JTorque_lim);
  
  /**
   * @brief: checks if probvided joint values are within their limits
   * @param q = joint position vector
   * @returns true if joints within limits
   */
  virtual bool CheckJointFeasibility(Eigen::VectorXd q);
  
  /**
   * @brief: computes forward kinematics
   * @param q = joint position vector
   * @param Pose = cartesian ee pose
   */
  virtual bool FwdKine(Eigen::VectorXd q, Eigen::Matrix4d &Pose);
  
  /**
   * @brief: computes orientation error. In this case formulated as angle axis wrt base frame.
   * @param R = end-effector rotation matrix
   * @returns orientation vector
   */ 
  virtual  Eigen::Vector3d getOrient(Eigen::MatrixXd R); 
  
    /**
   * @brief: computes orientation error. In this case formulated as RPY.
   * @param R = end-effector rotation matrix
   * @returns orientation vector
   */
  virtual  Eigen::Vector3d getOrientRPY(Eigen::MatrixXd R); 
  
  /**
   * @brief: returns Jacobian matrix
   */  
  virtual bool getJacobian(Eigen::MatrixXd &J,Eigen::VectorXd q);
  
  /**
   * @brief: computes the 3 kinmeatic measures
   * @returns vector of 3 values = kinematic dexterity measures
   */
  virtual std::vector<double> DextMeasure(Eigen::VectorXd q); 
  
  /**
   * @brief: computes the 3 dynamic measures
   * @returns vector of 3 values = dynamic dexterity measures
   */
  virtual std::vector<double> DynamicDextMeasure(Eigen::VectorXd q); 
  
  /**
   * @brief: computes ee WS
   * @param n_samples = number of samples for each joint
   * @param space_bounds =  values of minimum and maximum volume to consider in x,y,z
   * @param space_res = resolution for space discretization
   * @returns set of worksapce points and dextrity value
   */
  std::vector<Eigen::VectorXd> getWorkspace(int n_samples, std::vector<std::vector<double>> space_bounds, double space_res = 1e-03 );
  
  /**
   * @brief: computes joint torques
   * @param q,qd,qdd = joint veposition, velocity, acceleration vectors
   */  
  Eigen::VectorXd InverseDyn(Eigen::VectorXd q, Eigen::VectorXd qd, Eigen::VectorXd qdd);
  
  /**
   * @brief: computes robot inertia matrix
   */
  Eigen::MatrixXd getInertiaMatrix(Eigen::VectorXd q);
  
  /**
   * @brief: computes dynamic nonlinear term (Coriolis+gravity)
   */
  Eigen::VectorXd getNonlinear(Eigen::VectorXd q, Eigen::VectorXd qd);
  

  
  
private:
  
  Eigen::Matrix4d m_init_transform;
  KDL::Tree m_robot_tree;
  KDL::Chain m_robot_chain;
  
  int m_n_joints;
  int m_n_segs;
  
  std::vector<Eigen::VectorXd> m_JPos_lim;
  std::vector<Eigen::VectorXd> m_JTorque_lim;
  
  KDL::ChainFkSolverPos_recursive *m_FwdKineSolver;
  KDL::ChainJntToJacSolver* m_JacSolver;
  KDL::ChainDynParam *m_ChainDynParam;
  KDL::ChainIdSolver_RNE *m_IdSolver;
  
  /**
   * @brief: run each possible combination for robot configuration
   */
  void WS(const std::vector<Eigen::VectorXd>  &allVecs, int vecIndex, Eigen::VectorXd qSoFar,
	  std::vector<Eigen::VectorXd> &res, boost::multi_array<bool,3> &spacematrix, std::vector<double> space_bounds_min, double space_res);
  
  
  /**
   * @brief: fucntion for computing pseudoinverse
   * @param J = generic matrix
   */  
  Eigen::MatrixXd Pinv(Eigen::MatrixXd J);
  
  /**
   * @brief: freturns singular values of a mtarix
   * @param J = generic matrix
   */
  Eigen::VectorXd getSingValues(Eigen::MatrixXd J);
  
};

#endif