function figure_three(array_data)
%% Figure 3. Summary heat map with array number and Days Post Implant on y and x axes and \
    % color denoting number of units or mean SNR. 
  
figure('name','Long-term, chronic array recordings','visible','on','color','w');   
scatter([array_data.relative_days],[array_data.implantation_date],([array_data.num_good_channels_corrected]+.01),[array_data.SNR_all_channels])
xlabel('days post implant (days)');
ylabel('absolute implantation date (days)');
colormap(jet);
colorbar;
end