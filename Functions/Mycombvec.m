function y = Mycombvec(M)
%COMBVEC Create all combinations of vectors.
%
%  <a href="matlab:doc combvec">combvec</a>(A1,A2,...) takes any number of inputs A, where each Ai has
%  Ni columns, and return a matrix of (N1*N2*...) column vectors, where
%  the columns consist of all combinations found by combining one column
%  vector from each Ai.
%
%  For instance, here the four combinations of two 2-column matrices are
%  found.
%  
%    a1 = [1 2 3; 4 5 6];
%    a2 = [7 8; 9 10];
%    a3 = <a href="matlab:doc combvec">combvec</a>(a1,a2)

% Mark Beale, 12-15-93
% Copyright 1992-2010 The MathWorks, Inc.

[rows,~] = size(M);

if length(M) == 0
  y = [];
else
  y = M(1,:);
  for i=2:rows
    z = M(i,:);
    y = [copy_blocked(y,size(z,2)); copy_interleaved(z,size(y,2))];
end
end

%=========================================================
function b = copy_blocked(m,n)

[mr,mc] = size(m);
b = zeros(mr,mc*n);
ind = 1:mc;
for i=[0:(n-1)]*mc
  b(:,ind+i) = m;
end
%=========================================================

function b = copy_interleaved(m,n)

[mr,mc] = size(m);
b = zeros(mr*n,mc);
ind = 1:mr;
for i=[0:(n-1)]*mr
  b(ind+i,:) = m;
end
b = reshape(b,mr,n*mc);
