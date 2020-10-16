%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/31
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : 2-D Mean Filter
%                sv2: filtering window size.
%==========================================================================

function [meanImg] = meanFilt2_v2(inImg,sv2)

% Default parameters
switch nargin
    case 2
        % All arguments were provided, do nothing
    case 1
        sv2 = 5;
    otherwise
        warning('Please check input arguments!');
        return;
end

[~,~,c] = size(inImg);
paddedImg = sympad(inImg,sv2);
H = ones(sv2)/(sv2*sv2);

switch c
    case 1 % grayscale image
        temp = imfilter(paddedImg,H);
        meanImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2);
    case 3 % RGB image
        temp = zeros(size(paddedImg));
        temp(:,:,1) = imfilter(paddedImg(:,:,1),H);
        temp(:,:,2) = imfilter(paddedImg(:,:,2),H);
        temp(:,:,3) = imfilter(paddedImg(:,:,3),H);
        meanImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2,:);
    otherwise
        warning('Invalid input image!');
        return;
end

end
