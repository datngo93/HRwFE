function [J] = dehazing_algorithm(I,...
                                  Nc1,Nc2,f,...
                                  filtCoeffSel,...
                                  t1,t2,pu,pl,...
                                  d0,wt1,wt2,...
                                  beta,...
                                  theta0,theta1,theta2,...
                                  wbsv,wbkfo4,wbkfo5,wbkfo6,wbbalance,...
                                  wa,...
                                  hrsv)
%DEHAZINGALGORITHM The dehazing algorithm proposed by Ngo et al.
%   I: uint8 input RGB image.
%   Nc1: weight factor of lower limit's constraint 1
%   Nc2: weight factor of lower limit's constarint 2
%   f: weight factor in constraint 2
%   filtCoeffSel: select filter to remove background noise
%   t1, t2: range of trans. values in which weight factor linearly changes
%   pl, pu: lower and upper limit of weight factor for estimated transmission map
%   d0, wt1, wt2: for resolving color distortion
%   beta: atmospheric scattering coefficient, t = exp(-beta*d)
%   theta0, theta1, theta2: coefficients of CAP's model
%   wbsv: window size for filtering operations in White Balance
%   wbkfo4: weight factor in White Balance
%   wbkfo5: weight factor in White Balance
%   wbkfo6: weight factor in White Balance
%   wbbalance: weight factor in White Balance
%   wa: weight factor for false enlargement compensation
%   hrsv: window size for filtering operations in the main algorithm
%   J: double output dehazed image.

%====================== Input Checking =====================
[~,~,c] = size(I);
if (c~=3)
    warning('Input image must be RGB image (Height-by-Width-by-3)!');
    return;
else
    if (isinteger(I))
        dI = double(I)/255;
    else
        % assume that I is already in the range [0,1]
        dI = I;
    end
end
dI(dI==0) = 1/255; % prevent divide by 0
%===========================================================

%====================== White Balance ======================
[wb,light] = localWB(dI,wbkfo4,wbkfo5,wbkfo6,wbbalance,wbsv);
%===========================================================

%=================== Airlight Estimation ===================
[~,~,~,~,a] = qtSubAl(wb);
%===========================================================

%==================== Depth Estimation =====================
hsvI = rgb2hsv(wb);
switch filtCoeffSel
    case 1 % narrow (0.16pi)
        h5 = [3,1,1,1,3;1,1,1,1,1;1,1,0,1,1;1,1,1,1,1;3,1,1,1,3]/32; % Narrow - Let's use this filter as default
    case 2 % medium (0.19pi)
        h5 = [1,1,1,1,1;1,2,2,2,1;1,2,0,2,1;1,2,2,2,1;1,1,1,1,1]/32;
    case 3 % wide (0.20pi)
        h5 = [1,1,1,1,1;1,1,2,1,1;1,2,4,2,1;1,1,2,1,1;1,1,1,1,1]/32;
    otherwise
        warning('Invalid value of filtCoeffSel!')
        return;
end
s = weightedMeanFilt2_v2(hsvI(:,:,2),h5);
v = hsvI(:,:,3);
dP = theta0+theta1*v+theta2*s;
dP(dP<0) = 0; % limit depth map
refineDR = hmfm_v33(dP,hrsv); % refine depth map
%===========================================================

%==================== Transmission map =====================
tR = exp(-beta*refineDR);
%===========================================================

%============== Transmission map constraints ===============
wbGray = rgb2gray(wb);
w = min(wb,[],3);
w = hmfm_v33(w,hrsv);
alpha = meanFilt2_v2(wbGray,hrsv)./max(wbGray(:));
fc1 = (1-alpha)*(Nc1-1)+1;
fc2 = Nc2;
meanI = mean(wbGray(:));
stdI = std2(wbGray);
aMean = mean(a);
c1 = 1-((fc1.*w)/aMean);
c2 = 1-fc2.*((1/aMean).*(meanI-f*stdI));
c = max(c1,c2);
%===========================================================

%============== Constrainted transmission map ==============
t = tR;
pw = zeros(size(t));
pw(t<t1) = pu;
pw(t>t2) = pl;
pw((t>=t1)&(t<=t2)) = ((pu-pl)/(t1-t2))*t((t>=t1)&(t<=t2))+pu+((pu-pl)/(t2-t1))*t1;
trans = max(pw.*t,c); % since depth is lower-limited by 0, we don't need upper-limited by 1 for trans 
%===========================================================

%====================== Scene Recovery =====================
wt = ones(size(refineDR))*wt2;
wt(refineDR<d0) = refineDR(refineDR<d0).*((wt2-wt1)/d0)+wt1;

maxa = max(a,[],'all');
maxi = max(wb,[],'all');
a = a+wa*(maxi-maxa);
nwb = wb;
J = (nwb-a)./trans+a.*wt;
J = J.*light;

J(J<0) = 0;
J(J>1) = 1;

end
