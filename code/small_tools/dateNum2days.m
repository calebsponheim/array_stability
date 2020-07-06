function [days] = dateNum2days(date)

if numel(num2str(date))==6
%string must be YYMMDD (numel = 6)
date_temp = num2str(date);
y = str2double(date_temp(1:2));
m = str2double(date_temp(3:4));
d = str2double(date_temp(5:6));

days = 365*y + 30*m + d;
elseif numel(num2str(date))==5
date_temp = num2str(date);
date_temp = ['0' date_temp];
y = str2double(date_temp(1:2));
m = str2double(date_temp(3:4));
d = str2double(date_temp(5:6));

days = 365*y + 30*m + d;

else
    disp('dateString2days.m: dateString length is not 6. Returning 0 days.')
    days = 0;
end
end%function