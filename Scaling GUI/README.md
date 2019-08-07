# WS Generation
This project is for scaling master and slave workspaces.
## The Configuration File
The configuration file must contain the master and slave workspaces files and a transformation matrix.
The transformation matrix is 4x4 and corresponds to Rotation,position of the slave fram wrt master frame.
The first three elements of the last row are the initial scaling.
## Getting Started
- Load the config file: e.g file = "robots_config.txt";
- Run the GUI: e.g GUI(file)
- Start scaling
