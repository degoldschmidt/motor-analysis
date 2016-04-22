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
color(:,5) = [ 0.333  1.      .333 ];   %% GREEN
color(:,6) = [ 0.     1.      .667 ];   %% CYAN
color(:,7) = [ 0.     0.333  1.    ];   %% BLUE
color(:,8) = [ 0.667  0.     1.    ];   %% VIOLET
block={'Train','Test','After'};

for file=1:length(all_analysis)
    analysis=all_analysis{1};
    n_subjs = length(analysis);
    
    for subj=1:1
        for bl=2:2
            %subplot(1,3,bl);
            polar(0,500,'-k');
            hold on;
            first = analysis{1,subj}.(block{bl}).TrajsTang;
            for dir=1:8
                for i=1:length(first)
                    [dir i]
                    traj = cell2mat(first(i,dir));
                    if length(traj)>0
                        x= traj(:,1);
                        y= traj(:,2);
                        theta = atan2(y,x);
                        rho = sqrt(x.*x+y.*y);
                        h = polar(theta, rho);
                        %rlim= 500;
                        %axis([-1 1 -1 1]*rlim);
                        hold on;
                        set(h, 'Color', color(:,dir));
                    end
                end
            end
            hold off;
        end
        %axis tight;
        print(['polar_individual_' num2str(subj) '.png'],'-dpng', '-r300');
    end
    
end
end
