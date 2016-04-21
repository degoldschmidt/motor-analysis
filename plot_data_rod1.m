function [] = plot_data_rod1( all_analysis )
%PLOT_DATA_ROD1 - have the analysis file in your workspace and run it to
%plot cool stuff
%   Detailed explanation goes here

for file=1:length(all_analysis)
    
    analysis=all_analysis{file};
    n_subjects = length(analysis);
    block={'Train','Test','After'};
    for i=1:3
        angleError.(block{i})=zeros(length(analysis{1,1}.(block{i}).ErrAngss),n_subjects);
    end
    for j=1:3
        for i=1:n_subjects
            angleError.(block{j}) =  cat(2,angleError.(block{j}),analysis{1,i}.(block{j}).ErrAngss);
        end
    end
    
    figure
    for j=1:3
        h(j)=subplot(3,1,j);
        plot(smooth(mean(angleError.(block{j}),2)))
        ylabel(block{j})
        xlabel('Trials')
        ylim([-20 20])
    end
    title(h(1),[analysis{1,1}.task_version, ' - n=' ,num2str(n_subjects)]);
    
end
end

