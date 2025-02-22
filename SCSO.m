%___________________________________________________________________%
%   SAND CAT OPTIMIZATION ALGORITHM source codes                    %
%   Author and programmer: AMIR SEYYEDABBASI                        %
%   e-Mail: amir.seyedabbasi@gmail.com                              %                                                                 %
%   Main paper: A. Seyyedabbasi, F. kiani                           %
%   DOI: https://doi.org/10.1007/s00366-022-01604-x                 %
%___________________________________________________________________%
function [Best_Score,BestFit,Convergence_curve]=SCSO(SearchAgents_no,Max_iter,lb,ub,dim,fobj)
BestFit=zeros(1,dim);
Best_Score=inf;
Positions=initialization(SearchAgents_no,dim,ub,lb);
Convergence_curve=zeros(1,Max_iter);
t=0;
p=[1:360];
while t<Max_iter
    for i=1:size(Positions,1)
%         Positions(i,:)=Positions(i,:).*Levy(dim);
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        fitness=fobj(Positions(i,:));
        if fitness<Best_Score
            Best_Score=fitness;
            BestFit=Positions(i,:);
        end
    end
    S=2;                                    %%% S is maximum Sensitivity range 
    rg=S-((S)*t/(Max_iter));                %%%% guides R
   for i=1:size(Positions,1)
        r=rand*rg;
        R=((2*rg)*rand)-rg;                 %%%%   controls to transtion phases  
        for j=1:size(Positions,2)
        teta=RouletteWheelSelection(p);
           if((-1<=R)&&(R<=1))              %%%% R value is between -1 and 1
                Rand_position=abs(rand*BestFit(j)-Positions(i,j));
                Positions(i,j)=BestFit(j)-r*Rand_position*cos(teta);
           else                 
                cp=floor(SearchAgents_no*rand()+1);
                CandidatePosition =Positions(cp,:);
                Positions(i,j)=r*(CandidatePosition(j)-rand*Positions(i,j));
            end
        end
    end
    t=t+1;
    Convergence_curve(t)=Best_Score;
end
end

function X=initialization(N,Dim,UB,LB)

B_no= size(UB,2); % numnber of boundaries

if B_no==1
    X=rand(N,Dim).*(UB-LB)+LB;
end

% If each variable has a different lb and ub
if B_no>1
    for i=1:Dim
        Ub_i=UB(i);
        Lb_i=LB(i);
        X(:,i)=rand(N,1).*(Ub_i-Lb_i)+Lb_i;
    end
end
end

function [index] = RouletteWheelSelection(x)

    index=find(rand() <= cumsum(x) ,1,'first');

end