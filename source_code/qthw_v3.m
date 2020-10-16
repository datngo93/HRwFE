%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/10/15
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : Airlight estimation algorithm for hardware design
%==========================================================================

function [a,mask,ya,xa] = qthw_v3(inImg,minWin,xstart,xsize,xjump,xnum,xnumMax,ystart,ysize,yjump,ynum,ynumMax)

%=========== Defaut parameter ===========
switch nargin
    case 1
        minWin = 5;
        xstart = 0;
        xsize = 32;
        xjump = xsize;
        xnum = 128;
        xnumMax = 128; % 4016/32
        ystart = 0;
        ysize = 16;
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 2
        xstart = 0;
        xsize = 32;
        xjump = xsize;
        xnum = 128;
        xnumMax = 128; % 4016/32
        ystart = 0;
        ysize = 16;
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 3
        xsize = 32;
        xjump = xsize;
        xnum = 128;
        xnumMax = 128; % 4016/32
        ystart = 0;
        ysize = 16;
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 4
        xjump = xsize;
        xnum = 128;
        xnumMax = 128; % 4016/32
        ystart = 0;
        ysize = 16;
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 5
        xnum = 128;
        xnumMax = 128; % 4016/32
        ystart = 0;
        ysize = 16;
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 6
        xnumMax = 128; % 4016/32
        ystart = 0;
        ysize = 16;
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 7
        ystart = 0;
        ysize = 16;
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 8
        ysize = 16;
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 9
        yjump = ysize;
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 10
        ynum = 135;
        ynumMax = 135; % 2160/16
    case 11
        ynumMax = 135; % 2160/16
    case 12
        % all parameters are provided
    otherwise
        warning('Please check input parameters!');
        return;
end
%========================================

%============ Input Checking ============
[hei,wid,c] = size(inImg);
if (c~=3)
    warning('Input image must be RGB image (Height-by-Width-by-3)!');
    return;
else
    if (isinteger(inImg))
        inImg = double(inImg)/255;
    else
        % assume that inImg is already in the range [0,1]
    end
end
if ((xnum>xnumMax)||(ynum>ynumMax))
    warning('xnum(ynum) cannot be larger than xnumMax(ynumMax)!');
    return;
elseif ((xjump<1)||(yjump<1))
    warning('xjump(yjump) must be greater than or equal to 1!');
    return;
end
%========================================

%============ Air-light Est. ============
inImg = rgb2gray(inImg);
inImg = minFilt2(inImg,minWin,'sliding');
xcnt = 0;
ycnt = 0;
mask = ones([hei,wid]);
a = 0;
xa = inf;
ya = inf;
% for y = ystart+1:ysize+yjump:round(hei/2)-ysize+1 % search only upper half
%     ycnt = ycnt+1;
%     if (((y+ysize-1)>round(hei/2))||(ycnt>ynum))
%         break;
%     else
%         for x = xstart+1:xsize+xjump:wid-xsize+1
%             xcnt = xcnt+1;
%             if (((x+xsize-1)>wid)||(xcnt>xnum))
%                 break;
%             else
%                 localPatch = inImg(y:y+ysize-1,x:x+xsize-1);
%                 localPatchMean = mean(localPatch(:));
%                 if (localPatchMean>a)
%                     a = localPatchMean; % update
%                     ya = y;
%                     xa = x;
%                 else
%                     % not change
%                 end
%                 localPatchMask = ones([ysize,xsize]);
%                 localPatchMask(1,:) = 0;
%                 localPatchMask(end,:) = 0;
%                 localPatchMask(:,1) = 0;
%                 localPatchMask(:,end) = 0;
%                 mask(y:y+ysize-1,x:x+xsize-1) = localPatchMask;
%             end
%         end
%         xcnt = 0;
%     end
% end
for y = ystart+1:ysize+yjump:hei-ysize+1 % search entire image
    ycnt = ycnt+1;
    if (((y+ysize-1)>hei)||(ycnt>ynum))
        break;
    else
        for x = xstart+1:xsize+xjump:wid-xsize+1
            xcnt = xcnt+1;
            if (((x+xsize-1)>wid)||(xcnt>xnum))
                break;
            else
                localPatch = inImg(y:y+ysize-1,x:x+xsize-1);
                localPatchMean = mean(localPatch(:));
                if (localPatchMean>a)
                    a = localPatchMean; % update
                    ya = y;
                    xa = x;
                else
                    % not change
                end
                localPatchMask = ones([ysize,xsize]);
                localPatchMask(1,:) = 0;
                localPatchMask(end,:) = 0;
                localPatchMask(:,1) = 0;
                localPatchMask(:,end) = 0;
                mask(y:y+ysize-1,x:x+xsize-1) = localPatchMask;
            end
        end
        xcnt = 0;
    end
end
a = cat(3,a,a,a);
%========================================

end
