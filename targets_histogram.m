function [] = targets_histogram( all_analysis, plot_individuals, save_fig )
close all;
%TARGETS_HISTOGRAM
% targets_histogram( all_analysis, plot_individuals, save_fig ) - function
% definition
%
% This function plots histograms for the pseudorandom target angles
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

for file=1:length(all_analysis)
    analysis=all_analysis{file};
    n_subjects = length(analysis);
    block={'Train','Test','After'};
    
    currtargets = analysis{1,1}.(block{1}).TargetAngle;
    currtargets = 180*currtargets/pi;
    targets(1,1) = {currtargets};
    cattar = currtargets;
    for subj=1:n_subjects
        for bl=1:length(block)
            currtargets = analysis{1,subj}.(block{bl}).TargetAngle;
            currtargets = 180*currtargets/pi;
            targets(subj,bl) = {currtargets};
            if (subj>1 || bl>1)
                cattar = vertcat(cattar, currtargets);
            end
        end    
    end
end
length(targets);
xbins1 = 0:45:360;

handle = figure;
[counts,centers] = hist(cattar,xbins1);
bar(centers, counts/sum(counts));
hold on;
plot(-25:1:385, 0.1111:0.1111,'k--', 'LineWidth', 1.5);
hold off;
title('All subjects, all parts','fontsize',18);
xlabel('Target angle [ \circ ]','fontsize',18);
ylabel('Normalized counts','fontsize',18);
axis([-25 385 0 0.14]);
set(gca,'fontsize',18);

h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 0.42 1.0],'EdgeColor','w');
saveTightFigure(handle, 'histogram_all.pdf');

if plot_individuals==1
    
    for subj=1:n_subjects
        length(targets);
        xbins1 = 0:45:360;
        for bl=1:length(block)
            %[bl subj bl+4*(subj-1)]
            subplot(1,length(block)+1, bl);
            [counts,centers] = hist(cell2mat(targets(subj,bl)),xbins1);
            bar(centers, counts/sum(counts));
            hold on;
            plot(-25:1:385, 0.1111:0.1111,'k--', 'LineWidth', 2.5);
            hold off;
            xlabel('Target angle [ \circ ]','fontsize',12);
            ylabel('Normalized counts','fontsize',12);
            axis([-25 385 0 0.25]);
            h = findobj(gca,'Type','patch');
            title(['Subject ' num2str(subj) ', ' block{bl}],'fontsize',12);
            set(h,'FaceColor',[0 0.42 1.0],'EdgeColor','w');
        end
       %[4 subj 4+4*(subj-1)]
        subplot(1,length(block)+1, 4);
        alltar = vertcat(cell2mat(targets(subj,1)), cell2mat(targets(subj,2)), cell2mat(targets(subj,3)));
        [counts,centers] = hist(alltar,xbins1);
        bar(centers, counts/sum(counts));
        hold on;
        plot(-25:1:385, 0.1111:0.1111,'k--', 'LineWidth', 2.5);
        hold off;
        xlabel('Target angle [ \circ ]','fontsize',12);
        ylabel('Normalized counts','fontsize',12);
        axis([-25 385 0 0.25]);
        h = findobj(gca,'Type','patch');
        title(['Subject ' num2str(subj) ', all parts'],'fontsize',12);
        set(h,'FaceColor',[0 0.17 1.0],'EdgeColor','w');
        
        %# create some plot, and make axis fill entire figure
        %plot([0 5 0 5], [0 10 10 0]), axis tight
        %set(gca, 'Position',[0 0 1 1])
        
        %# set size of figure's "drawing" area on screen
        set(gcf, 'Units','inches', 'Position',[0 0 15 3])
        
        %# set size on printed paper
        %#set(gcf, 'PaperUnits','centimeters', 'PaperPosition',[0 0 5 10])
        %# WYSIWYG mode: you need to adjust your screen's DPI (*)
        set(gcf, 'PaperPositionMode','auto')
        print(['histogram_individual_' num2str(subj) '.png'],'-dpng', '-r300');

end


end

end