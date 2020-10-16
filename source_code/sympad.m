%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/31
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : Symmetric padding
%==========================================================================

function inpad = sympad(in,sv)

[~,~,c] = size(in);
switch c
    case 1 % grayscale image
        inpad = sympad2(in,sv);
    case 3 % rgb image
        inpad = sympad3(in,sv);
    otherwise
end

end

function inpad = sympad2(in,sv)

padsize = size(in)+sv-1;
inpad = zeros(padsize);
inpad((sv+1)/2:end-(sv-1)/2,(sv+1)/2:end-(sv-1)/2) = in;

upmask = false(padsize(1),padsize(2));
upmask((sv+1)/2+1:sv,:) = true;
uppad = reshape(inpad(upmask),[(sv-1)/2,padsize(2)]);
uppad = uppad(end:-1:1,:);

lowmask = false(padsize(1),padsize(2));
lowmask(end-(sv-1):end-(sv-1)/2-1,:) = true;
lowpad = reshape(inpad(lowmask),[(sv-1)/2,padsize(2)]);
lowpad = lowpad(end:-1:1,:);

inpad(1:(sv+1)/2-1,:) = uppad;
inpad(end-(sv-1)/2+1:end,:) = lowpad;

leftmask = false(padsize(1),padsize(2));
leftmask(:,(sv+1)/2+1:sv) = true;
leftpad = reshape(inpad(leftmask),[padsize(1),(sv-1)/2]);
leftpad = leftpad(:,end:-1:1);

rightmask = false(padsize(1),padsize(2));
rightmask(:,end-(sv-1):end-(sv-1)/2-1) = true;
rightpad = reshape(inpad(rightmask),[padsize(1),(sv-1)/2]);
rightpad = rightpad(:,end:-1:1);

inpad(:,1:(sv+1)/2-1) = leftpad;
inpad(:,end-(sv-1)/2+1:end) = rightpad;

end

function inpad = sympad3(in,sv)

padsize = size(in)+sv-1;
padsize(3) = padsize(3)-sv+1;
inpad = zeros(padsize);
inpad((sv+1)/2:end-(sv-1)/2,(sv+1)/2:end-(sv-1)/2,:) = in;

upmask = false(padsize);
upmask((sv+1)/2+1:sv,:,:) = true;
uppad = reshape(inpad(upmask),[(sv-1)/2,padsize(2),padsize(3)]);
uppad = uppad(end:-1:1,:,:);

lowmask = false(padsize);
lowmask(end-(sv-1):end-(sv-1)/2-1,:,:) = true;
lowpad = reshape(inpad(lowmask),[(sv-1)/2,padsize(2),padsize(3)]);
lowpad = lowpad(end:-1:1,:,:);

inpad(1:(sv+1)/2-1,:,:) = uppad;
inpad(end-(sv-1)/2+1:end,:,:) = lowpad;

leftmask = false(padsize);
leftmask(:,(sv+1)/2+1:sv,:) = true;
leftpad = reshape(inpad(leftmask),[padsize(1),(sv-1)/2,padsize(3)]);
leftpad = leftpad(:,end:-1:1,:);

rightmask = false(padsize);
rightmask(:,end-(sv-1):end-(sv-1)/2-1,:) = true;
rightpad = reshape(inpad(rightmask),[padsize(1),(sv-1)/2,padsize(3)]);
rightpad = rightpad(:,end:-1:1,:);

inpad(:,1:(sv+1)/2-1,:) = leftpad;
inpad(:,end-(sv-1)/2+1:end,:) = rightpad;

end
