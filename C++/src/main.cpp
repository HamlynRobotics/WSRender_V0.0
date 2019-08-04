#include <iostream>
#include <robot.h>


/*
 * This function shows an example for computing the WS of a desired robot, provided an URDF file 
 */

void SaveData(std::ofstream &File, Eigen::VectorXd Values);

int main(int argc, char **argv) {
  
  std::string urdf_file = "my_urdf.urdf"; 
  
  // set limits
  std::vector<Eigen::VectorXd> JPos_lims(2);
  std::vector<Eigen::VectorXd> JTorque_lims(2);
  
  JPos_lims[0].resize(6);
  JPos_lims[1].resize(6);
  JTorque_lims[0].resize(6);
  JTorque_lims[1].resize(6);
  
  JPos_lims[0] << -M_PI, -M_PI/4,-M_PI/4,-M_PI/4,-M_PI/4,-M_PI/4;
  JPos_lims[1] = -JPos_lims[0];
  
  JTorque_lims[0] << -300, -300,-300,-300,-300,-300; 
  JTorque_lims[1] << -JTorque_lims[0];
  
  std::vector<std::string> first_last_link_name(2);
  
  first_last_link_name[0] = "my_first_link";
  first_last_link_name[1] = "my_last_link";
  
  Eigen::Vector3d grav; //gravity vector in base frame
  grav << 0., 0, -9.81;
  
  Robot Robot( urdf_file,  first_last_link_name, grav);
  
  Robot.setLims(JPos_lims, JTorque_lims);
  
  int n_samples = 11; // number of samples for joint sampling
  std::vector<std::vector<double>> space_bounds(2); //bounds for 3D space
  
  /*Set the space baounds to sve memry on WS file.
  These bounds are the overestimated and approximated min and max values (long x,y,z) that the robot can reach.
  */
  space_bounds[0] = {-0.2, -1., -0.2}; 
  space_bounds[1] = {0.2, 0, 0.2};
  
  std::vector<Eigen::VectorXd> WS = Robot.getWorkspace(n_samples, space_bounds);
  
  std::ofstream WS_file("my_WS_file.txt");
  
  std::cout<<"saving \n";
  for (int i = 0; i < WS.size(); i++)
  {
    SaveData(WS_file,WS[i]);
  }
  
  WS_file.close();
  
  return 0;
}

void SaveData(std::ofstream &File, Eigen::VectorXd Values)
{
  if (File.is_open())
  {
    for (int i = 0; i < Values.rows(); i++)
    {
      File<<Values[i]<<"\t";
      
    }
    File<<"\n";
  }
  return;
}
