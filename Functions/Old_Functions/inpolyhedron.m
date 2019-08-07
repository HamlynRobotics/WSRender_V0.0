
%Reference : Newsgroups: comp.graphics,comp.graphics.algorithms
%From: herron@cs.washington.edu (Gary Herron)

function inflag = inpolyhedron(point_set,p_detected)
% point_set: a set of points stores the coordinates
% p_detected: point to be detected
% inflag:
%      flag = 1: the point is in the polyhedron.
%      flag = 0: the point is not in the polyhedron.
% Powered by: Xianbao Duan xianbao.d@gmail.com
% stores the coordinates of the convexes.
tri = delaunayTriangulation(point_set);
% number of the tetrahedrons decomposed from the polyhedron
num_tet = size(tri,1);
t_inflag = zeros(1,11);
for i = 1:num_tet
 v1_coord = point_set(tri(i,1),:);
 v2_coord = point_set(tri(i,2),:);
 v3_coord = point_set(tri(i,3),:);
 v4_coord = point_set(tri(i,4),:);
 D0 =det( [v1_coord,1;v2_coord,1;v3_coord,1;v4_coord,1]);
 D1 = det([p_detected,1;v2_coord,1;v3_coord,1;v4_coord,1]);
 D2 = det([v1_coord,1;p_detected,1;v3_coord,1;v4_coord,1]);
 D3 = det([v1_coord,1;v2_coord,1;p_detected,1;v4_coord,1]);
 D4 = det([v1_coord,1;v2_coord,1;v3_coord,1;p_detected,1]);

 if D0*D1 > 0 && D0*D2>0 && D0*D3>0 && D0*D4 > 0
 t_inflag(i) = 1;
 break;
 end

end

if sum(t_inflag) > 0
 inflag = 1;
% disp('The point is in the polyhedron.');
else
 inflag = 0;
% disp('The point is not in the polyhedron.');
end