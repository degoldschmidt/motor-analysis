function [] = polar_traj( all_analysis, plot_individuals, save_fig )
close all;
%TARGETS_HISTOGRAM
% polar_traj( all_analysis, plot_individuals, save_fig ) - function
% definition
%
% This function plots trajectories in a polar plot
%
% all_analysis = analysis; %file in your workspace
% plot_individuals = 0 or 1; %plot a single figure per indivdual -carefull,
% this opens A LOT of new figures
% save_fig = 0 or 1; % to save figures.
%
% Have the ANALYSIS file in your workspace and simply run
% the function like in example 1.
% If you would like to plot all analysis at the same time, create a cell
% with the analysis file inside - see example 2.
% EXAMPLES:
%  1-> targets_histogram( {analysis},0,1 ) - example
%  2-> targets_histogram( {analysis_v1, analysis_v2, analysis_v3},1,1 ) - example
%


color(:,1) = [ 1.     0.      .667 ];   %% MAGENTA 
color(:,2) = [ 1.      .333  0.    ];   %% RED
color(:,3) = [ 1.      .667  0.    ];   %% ORANGE
color(:,4) = [ 1.     1.      .333 ];   %% YELLOW
color(:,5) = [ 0.     1.     0.    ];   %% GREEN
color(:,6) = [ 0.     1.     1.    ];   %% CYAN
color(:,7) = [ 0.     0.333  1.    ];   %% BLUE
color(:,8) = [ 0.667  0.     1.    ];   %% VIOLET
block={'Train','Test','After'};
rcut = 520;

for file=1:length(all_analysis)
    analysis=all_analysis{1};
    n_subjs = length(analysis);
    
    for subj=1:1 %%n_subjs
        ['Subject ' num2str(subj)]
        for bl=1:length(block)
            subplot(1,3,bl);
            polar(0,500,'-k');
            hold on;
            first = analysis{1,subj}.(block{bl}).TrajsTang;
            
            for dir=1:8
                % Averages for different directions
                th_avg = {};
                r_avg = {};
                
                for i=1:length(first)
                    %[dir i]
                    traj = cell2mat(first(i,dir));
                    meanth = NaN(100,length(first));
                    meanrho = NaN(100,length(first));
                    if (length(traj)>0 && length(traj)<100)
                        x= traj(:,1);
                        y= traj(:,2);
                        theta = atan2(y,x);
                        rho = sqrt(x.*x+y.*y);
                        %meanth(1:length(theta(rho<rcut)), i) = theta(rho<rcut);
                        %meanrho(1:length(rho(rho<rcut)), i) = rho(rho<rcut);
                        
                        h = polar(theta(rho<rcut), rho(rho<rcut));
                        
                        %REMOVE DISTANCE LABELS
                        hax = findall(gca,'type','text');
                        set(hax,'fontsize', 6);          % change fontsize for axes
                        legit = {'0','30','60','90','120','150','180','210','240','270','300','330',''};
                        idx   = ~ismember(get(hax,'string'),legit);
                        set(hax(idx),'string','');
                        %polarticks(8,h)
                        
                        %subplot specs
                        title(block{bl});    
                        
                        hold on;
                        set(h, 'Color', color(:,dir));  % Linecolor = target angle
                    end
                end
  
                % Plot average
                %hold on;
                %h = polar(nanmean(meanth, 2), nanmean(meanrho, 2), 'k-');
                
            end
            %set_title(['Subject' num2str(subj)]);
            hold off;
        end
        %axis tight;
        %# set size of figure's "drawing" area on screen
        set(gcf, 'Units','inches', 'Position',[0 0 7.5 3])
        
        %# set size on printed paper
        %#set(gcf, 'PaperUnits','centimeters', 'PaperPosition',[0 0 5 10])
        %# WYSIWYG mode: you need to adjust your screen's DPI (*)
        set(gcf, 'PaperPositionMode','auto')
        print(['polar_individual_' num2str(subj) '.eps'],'-depsc', '-r900');
    end
    
end
end
