%_______________________________________________________________________________________%
%  Aquila Optimizer (AO) source codes (version 1.0)                                     %
%                                                                                       %
%  Developed in MATLAB R2015a (7.13)                                                    %
%  Author and programmer:                                                               %
%  Abualigah, L, Yousri, D, Abd Elaziz, M, Ewees, A, Al-qaness, M, Gandomi, A.          %
%         e-Mail: Aligah.2020@gmail.com      (Laith Abualigah)                          %
%       Homepage:                                                                       %
%         1- https://scholar.google.com/citations?user=39g8fyoAAAAJ&hl=en               %
%         2- https://www.researchgate.net/profile/Laith_Abualigah                       %
%                                                                                       %
%   Main paper:                                                                         %
%_____________Aquila Optimizer: A novel meta-heuristic optimization algorithm___________%
%_______________________________________________________________________________________%
% Abualigah, L, Yousri, D, Abd Elaziz, M, Ewees, A, Al-qaness, M, Gandomi, A. (2021). 
% Aquila Optimizer: A novel meta-heuristic optimization algorithm. 
% Computers & Industrial Engineering.
%_______________________________________________________________________________________%
function [Best_FF,Best_P,conv]=AO(N,T,LB,UB,Dim,F_obj)
Best_P=zeros(1,Dim);
Best_FF=inf;


X=initialization(N,Dim,UB,LB);
Xnew=X;
Ffun=zeros(1,size(X,1));
Ffun_new=zeros(1,size(Xnew,1));

t=1;


alpha=0.1;
delta=0.1;

while t<T+1
    for i=1:size(X,1)
        F_UB=X(i,:)>UB;
        F_LB=X(i,:)<LB;
        X(i,:)=(X(i,:).*(~(F_UB+F_LB)))+UB.*F_UB+LB.*F_LB;
        Ffun(1,i)=F_obj(X(i,:));
        if Ffun(1,i)<Best_FF
            Best_FF=Ffun(1,i);
            Best_P=X(i,:);
        end
    end
    
    
    G2=2*rand()-1; % Eq. (16)
    G1=2*(1-(t/T));  % Eq. (17)
    to = 1:Dim;
    u = .0265;
    r0 = 10;
    r = r0 +u*to;
    omega = .005;
    phi0 = 3*pi/2;
    phi = -omega*to+phi0;
    x = r .* sin(phi);  % Eq. (9)
    y = r .* cos(phi); % Eq. (10)
    QF=t^((2*rand()-1)/(1-T)^2); % Eq. (15)
        %-------------------------------------------------------------------------------------
    for i=1:size(X,1)
        %-------------------------------------------------------------------------------------
        if t<=(2/3)*T
            if rand <0.5
                Xnew(i,:)=Best_P(1,:)*(1-t/T)+(mean(X(i,:))-Best_P(1,:))*rand(); % Eq. (3) and Eq. (4)
                Ffun_new(1,i)=F_obj(Xnew(i,:));
                if Ffun_new(1,i)<Ffun(1,i)
                    X(i,:)=Xnew(i,:);
                    Ffun(1,i)=Ffun_new(1,i);
                end
            else
                %-------------------------------------------------------------------------------------
                Xnew(i,:)=Best_P(1,:).*Levy(Dim)+X((floor(N*rand()+1)),:)+(y-x)*rand;       % Eq. (5)
                Ffun_new(1,i)=F_obj(Xnew(i,:));
                if Ffun_new(1,i)<Ffun(1,i)
                    X(i,:)=Xnew(i,:);
                    Ffun(1,i)=Ffun_new(1,i);
                end
            end
            %-------------------------------------------------------------------------------------
        else
            if rand<0.5
                Xnew(i,:)=(Best_P(1,:)-mean(X))*alpha-rand+((UB-LB)*rand+LB)*delta;   % Eq. (13)
                Ffun_new(1,i)=F_obj(Xnew(i,:));
                if Ffun_new(1,i)<Ffun(1,i)
                    X(i,:)=Xnew(i,:);
                    Ffun(1,i)=Ffun_new(1,i);
                end
            else
                %-------------------------------------------------------------------------------------
                Xnew(i,:)=QF*Best_P(1,:)-(G2*X(i,:)*rand)-G1.*Levy(Dim)+rand*G2; % Eq. (14)
                Ffun_new(1,i)=F_obj(Xnew(i,:));
                if Ffun_new(1,i)<Ffun(1,i)
                    X(i,:)=Xnew(i,:);
                    Ffun(1,i)=Ffun_new(1,i);
                end
            end
        end
    end
    %-------------------------------------------------------------------------------------
%     if mod(t,100)==0
%         display(['At iteration ', num2str(t), ' the best solution fitness is ', num2str(Best_FF)]);
%     end
    conv(t)=Best_FF;
    t=t+1;
end

end

function o=Levy(d)
beta=1.5;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
u=randn(1,d)*sigma;v=randn(1,d);step=u./abs(v).^(1/beta);
o=step;
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
