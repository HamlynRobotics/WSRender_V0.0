% Example for running the scaling GUI for mapping master and slave
% workspaces

% [1] : run the function
% [2] : choose the WS to visualize (in this case only tot available for
% slave). Choose percentages (in increments of 0.1) and press "set Button"
% [3] : adjust "alpha for shapes" for better rendering
% [4] : press "start button" for starting scaling
% [5]: adjust offsets and scale factors.

function scaling_example

file = "robots_config.txt";

GUI(file);

end