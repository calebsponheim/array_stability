function [days] = dateNum2days(date)
% This function changes a date format into an absolute number of days
% (since AD 0??? I guess??). helps for all sorts of things.

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
    fprintf('dateString2days.m: dateString %i length is not 6. Returning 0 days. Check your data. \n',date)
    days = 0;
end
end%function