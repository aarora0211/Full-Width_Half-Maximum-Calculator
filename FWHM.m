% Author: Akshit Arora
% Date:   07/22/19
%____________________________FWHM________________________________
clear;
clc;
clf;

%reading excel file
num = xlsread('dystrophy_24_wk','T2_histograms') ;
temp1 = num(:,27);         

%delete null values
ind = ~isnan(temp1);
temp1 = temp1(ind);

for i = 1: 100
required_data(i) = temp1(i);
end
temp1 = required_data;
temp1 = temp1.';

%x values
x = 0:0.5:49.5;

% =fit the data with the specific trend(cubic/gaussian/etc)
f = fit(x.', temp1, 'gauss2');  %check 'gauss2'

%calculating fwhm
k = f(x);
[a,b,i,f0] = fwhm_fn(x.',k);  
%a left side value
%b right side value 
%i max height index number
%f0 fwhm value

pks = findpeaks(k);
check = size(pks) == 2;
if(check(1) == 1)
    result1 = find(k == pks(1));
    result2 = find(k == pks(2));
    for(i = 1: result1)
        gauss1(i) = k(i);
    end
    x1 = 0:0.5:result1/2 - 0.5;
    gauss1_fit = fit(x1.', gauss1.', 'gauss1');
    x_complete = 0:0.5:result1 - 0.5;
    gauss1_fit_pts = gauss1_fit(x_complete);
    plot(x_complete, gauss1_fit_pts, '--m'); hold on;

    count = 1;
    for(i = result2: size(k))
        gauss2(count) = k(i);
        count = count + 1;
    end
    flip(gauss2)
    x2 = result2/2 - 0.5: 0.5: 49.5;
    gauss2_fit = fit(x2.', flip(gauss2).', 'gauss1');
    x2_complete = result2/2 - 0.5: 0.5: 2 * 49.5 - result2/2;
    gauss2_fit_pts = gauss2_fit(x2_complete);
    x2_complete = x2_complete - (49.5 - result2/2); % +0.5 if needed
    plot(x2_complete, gauss2_fit_pts, '--b');
    plot(f,x,temp1, '.g', 'b'); 
    
    
    %fwhm gaussian fn 1
    [a,b,i,f1] = fwhm_fn(x_complete',gauss1_fit_pts)
    f1
    plot(a, gauss1_fit_pts(i)/2, 'd');
    plot(b, gauss1_fit_pts(i)/2, 'd');
    line([a, b], [gauss1_fit_pts(i)/2, gauss1_fit_pts(i)/2])
    
    %fwhm gaussian fn 2

    [a,b,i,f2] = fwhm_fn(x2_complete.', gauss2_fit_pts);
    f2
    plot(a, gauss2_fit_pts(i)/2, 'd');
    plot(b, gauss2_fit_pts(i)/2, 'd');
    line([a, b], [gauss2_fit_pts(i)/2, gauss2_fit_pts(i)/2])
    %legend('gaussian 1', 'gaussian 2', 'data points', 'excluded points', 'point 1', 'point 2')
    title(["FWHM Gaussian 1 = ", num2str(f1), "FWHM Gaussian 2 = ", num2str(f2)])
    
else 

f = fit(x.', temp1, 'gauss1'); 
k = f(x);
[a,b,i,f0] = fwhm_fn(x.',k);  

    %                                 plotting
    plot(f,x,temp1, '.g', 'b'); hold on;
    plot(a, k(i)/2, 'd');
    plot(b, k(i)/2, 'd');
    line([a, b], [k(i)/2, k(i)/2])
    legend('data', 'excluded-data', 'curve', 'point-1', 'point-2', 'fwhm')
    title(["FWHM = ", num2str(f0)])
    %print(gcf,'-dpng','FWHW_day_03_mdx.png');
end