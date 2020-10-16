%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/06
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : 2-D Minimum Filter
%==========================================================================

function [minImg] = maxFilt2(inImg,sv2,slidingOp)
%MINFILT2 2-D minimum filter.
%   sv2: filtering window size.
%   slidingOp: sliding option, "sliding" or "distinct".

% Default parameters
switch nargin
    case 3
        % All arguments were provided, do nothing
    case 2
        slidingOp = 'sliding';
    case 1
        sv2 = 5;
        slidingOp = 'sliding';
    otherwise
        warning('Please check input arguments!');
        return;
end

[~,~,c] = size(inImg);
padsize = floor((sv2-1)/2);
paddedImg = padarray(inImg,[padsize,padsize],-Inf);

switch c
    case 1 % grayscale image
        temp = colfilt(paddedImg,[sv2,sv2],slidingOp,@customMax);
        minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2);
    case 3 % RGB image
        temp = zeros(size(paddedImg));
        temp(:,:,1) = colfilt(paddedImg(:,:,1),[sv2,sv2],slidingOp,@customMax);
        temp(:,:,2) = colfilt(paddedImg(:,:,2),[sv2,sv2],slidingOp,@customMax);
        temp(:,:,3) = colfilt(paddedImg(:,:,3),[sv2,sv2],slidingOp,@customMax);
        minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2,:);
    otherwise
        warning('Invalid input image!');
        return;
end

    % Customized max function
    function [out] = customMax(in)
        switch slidingOp
            case 'sliding'
                out = max(in);
            case 'distinct'
                out = repmat(max(in),[size(in,1),1]);
            otherwise
                warning('Invalid input value!');
                return;
        end
    end

end
