function varargout = RDF_Analyser_GUI(varargin)
%
% RDF_ANALYSER_GUI MATLAB code for RDF_Analyser_GUI.fig
%
    % RDF_ANALYSER_GUI is an interactive and integrated tool to extract reduced 
    % density functions (RDF) from electron diffraction patterns, and works
    % for material compositions with upto 5 elements. For help on how to use 
    % the tool, please see the PDF User Manual. This program is free
    % software, covered under the terms of GNU General Public License v3.
%
    % Copyright (c) v1.0 [2016] --------------------------------------------------------
    % Janaki Shanmugam & Konstantin B. Borisenko
    % Electron Image Analysis Group, Department of Materials
    % University of Oxford
    % --------------------------------------------------------------------
%
%      RDF_ANALYSER_GUI, by itself, creates a new RDF_ANALYSER_GUI or raises 
%      the existing singleton*.
%
%      H = RDF_ANALYSER_GUI returns the handle to a new RDF_ANALYSER_GUI or the 
%      handle to the existing singleton*.
%
%      RDF_ANALYSER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RDF_ANALYSER_GUI.M with the given input arguments.
%
%      RDF_ANALYSER_GUI('Property','Value',...) creates a new RDF_ANALYSER_GUI or 
%      raises the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RDF_Analyser_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RDF_Analyser_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RDF_Analyser_GUI

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RDF_Analyser_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RDF_Analyser_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% Executes just before RDF_Analyser_GUI is made visible.
function RDF_Analyser_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RDF_Analyser_GUI (see VARARGIN)

% Choose default command line output for RDF_Analyser_GUI
handles.output = hObject;

% --- Default values to be used for fitting
% (in case edit box callback functions are not executed)
handles.ds = 1;
handles.e1 = 0;
handles.e2 = 0;
handles.e3 = 0;
handles.e4 = 0;
handles.e5 = 0;
handles.q_fixed = 0;
handles.dq = 0.1;
handles.N = 100;
handles.dN = 100;
handles.damping = 0.5;
handles.paramK = load('Kirkland_2010.txt','-ascii');
handles.param_val = 2;
handles.rmax = 10;
% display default values used for fitting
set(handles.text_q_fit, 'String', handles.q_fixed);
set(handles.text_N, 'String', handles.N);
set(handles.text_damping, 'String', handles.damping);
set(handles.popup_param, 'Value', 2);

set(handles.Tab1,'Value',1); %depressed Tab1
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = RDF_Analyser_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function About_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
(msgbox...
    ({'eRDF Analyser is distributed in the hope that it will be useful, but'...
    'without any warranty. This program is free software and you are welcome'...
    'to redistribute it under certain conditions.'...
    'See the GNU General Public License for more details'...
    '(http://www.gnu.org/licenses/).',...
    'Copyright (c) 2016; J Shanmugam, KB Borisenko'},...
    'About eRDF Analyser'));
% --------------------------------------------------------------------

% --- Executes on button press in Tab1.
function Tab1_Callback(hObject, eventdata, handles)
% hObject    handle to Tab1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Tab1
% --- Shows Diffraction Data panel
set(handles.Panel1,'Visible','On');
set(handles.Panel2,'Visible','Off');
set(handles.Tab2,'Value',0);

% --- Executes on button press in Tab2.
function Tab2_Callback(hObject, eventdata, handles)
% hObject    handle to Tab2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Tab2
% --- Shows RDF Plot tab
set(handles.Panel1,'Visible','Off');
set(handles.Panel2,'Visible','On');
set(handles.Tab1,'Value',0);

% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function ds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ds_Callback(hObject, eventdata, handles)
% hObject    handle to ds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ds as text
%        str2double(get(hObject,'String')) returns contents of ds as a double
% --- ds: Calibration factor input
ds = str2double(get(hObject,'String'));
if isnan(ds)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.ds = ds;

guidata(hObject,handles)

% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --- Executes on button press in button_OpenDP.
function button_OpenDP_Callback(hObject, eventdata, handles)
% hObject    handle to button_OpenDP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Choose data from input file (diffraction pattern image as text file)
[fname,pname] = uigetfile({'*.txt','Text files';'*.*','All files (*.*)';},'Choose input data file');
addpath(pname);
rehash toolboxcache;
handles.pname = pname;
dptxt = importdata(fname);

[pathstr,name,ext] = fileparts(fname); %#ok<ASGLU>
handles.DPfname = name;
guidata(hObject,handles)

nx = size(dptxt,1);
ny = size(dptxt,2);

% For better visualisation
ig = log(abs(dptxt)+1);
plim = mat2gray(ig);
DPfig = figure('Name','Diffraction Pattern','NumberTitle','off');
imshow(imadjust(plim),'InitialMagnification',25);

% Use median filter to remove single pixel noise
user_response = questdlg('Do you want to use a median filter to remove salt-and-pepper noise?',...
    'Remove salt-and-pepper noise',...
    'Yes','No','Cancel',...
    'Cancel');
switch user_response
    case 'Yes'
	% Apply median filter to remove single pixel noise
	dp = medfilt2(dptxt);
    % For better visualisation
    ig = log(abs(dp)+1);
    plim = mat2gray(ig);
    imshow(imadjust(plim),'InitialMagnification',25);
    case 'No'
	% take no action
    dp = dptxt;
end

% ------------------------------------------------------
%% Mask beam stop
% ------------------------------------------------------
% Alert user to mask beam stop with freehand mask
uiwait(msgbox('Click and drag to draw a freehand ROI to mask beam stop',...
    'Mask beam stop'));
% Create freehand ROI
hFH = imfreehand();
binaryMask = hFH.createMask();

% Burn mask into image by setting it to NaN (0) wherever the mask is true.
dp(binaryMask) = NaN;
ig(binaryMask) = 0;

% Display the masked image
plim = mat2gray(ig);
imshow(imadjust(plim),'InitialMagnification',25);
hold on;

% -------------------------------------------------------
%% Additional Mask
% ------------------------------------------------------
% Alert user to create additional freehand mask if necessary
uiwait(msgbox...
    ('Click and drag to draw a freehand ROI to select additional mask',...
    'Additional Mask'));
% Create freehand ROI
hFH = imfreehand();
binaryMask2 = hFH.createMask();

% Burn mask into image by setting it to NaN (0) wherever the mask is true.
dp(binaryMask2) = NaN;
ig(binaryMask2) = 0;

% Display the masked image
plim = mat2gray(ig);
imshow(imadjust(plim),'InitialMagnification',25);
hold on;
% ------------------------------------------------------
%% Find centre
% -------------------------------------------------------
% change colormap of diffraction pattern to colorcube
figure(DPfig);
colormap(colorcube);

% Define initial centre as a centre of mass

dpm=dptxt;
dpm(binaryMask)=0;
tint=sum(sum(dpm));
[xlc,ylc]=meshgrid(1:ny,1:nx);
xlm=sum(sum(xlc.*dpm));
ylm=sum(sum(ylc.*dpm));
xc=xlm/tint;
yc=ylm/tint;

xmid=0.5*nx;
% ymid=0.5*ny;
diameter = 0.5*xmid;
radius = 0.5*diameter;
xMin= xc - radius;
yMin = yc - radius;

% create ellipse
hEllipse = imellipse(gca,[xMin, yMin, diameter, diameter]);
hEllipse.setFixedAspectRatioMode( 'true' );

% Alert user to adjust ellipse position and double click when finished
helpdlg({'Move and resize marker to define diffraction ring.',...
    'Double-click inside ellipse once finished.'},...
    'Adjust ellipse marker');

% wait for double-click -> get position
wait(hEllipse);
pos = hEllipse.getPosition;

% Plot the center and ellipse
hold on;
rad = 0.5*pos(3);
dm = pos(3);
xcentre = pos(1)+rad;
ycentre = pos(2)+rad;
rectangle('Position',[xcentre-rad, ycentre-rad, dm, dm], ...
    'Curvature', [1,1], 'EdgeColor', 'white', 'LineWidth', 2);
plot(xcentre, ycentre, 'r+', 'LineWidth', 1, 'MarkerSize', 20);
delete(hEllipse);
% -------------------------------------------------------

%% Let user choose to continue or optimise centre
% ------------------------------------------------------
% default choice: Continue with previous selection
choice = questdlg('Do you want to optimise the centre position or continue?',...
    'Optimise Centre',...
    'Continue with selection','Run optimisation routine',...
    'Continue with selection');
switch choice
    case 'Continue with selection'
        % do nothing --> continue with azav/azvar routine
    case 'Run optimisation routine'       
        % Input dialog for optimisation parameters
        prompt = {'Enter number of projections:',...
            'Enter distance of contour from edge (in pixels)',...
            'Enter size of grid scan (in pixels)'};
        % default values
        def = {'100','100','25'};
        opt_input = inputdlg(prompt,'Optimisation parameters',1,def);
        % input values into variables
        nnp = str2double(opt_input{1});
        dedge = str2double(opt_input{2});
        maxshift = str2double(opt_input{3});            
        % -------------------------------------------------------       
        %Optimize the circle position globally with upscaled precision
        % ------------------------------------------------------- 
        scale = 10;
        
        % Redefine initial outline with more points between selected angles
        amin=-85*pi/180;
        amax=85*pi/180;
        alpha=amin:(amax-amin)/(nnp-1):amax;
        outline=zeros(nnp,2);
        outline(:,1)=rad*cos(alpha)+xcentre;
        outline(:,2)=rad*sin(alpha)+ycentre;

        % Coordinates of the line scans
        sl=zeros(nnp,1);
        cc=zeros(nnp,1);
        
        hold all;
        for nn=1:nnp
            vv=outline(nn,1)-xcentre;
            sl(nn)=(outline(nn,2)-ycentre)/vv;
            cc(nn)=scale*(outline(nn,2)-sl(nn)*outline(nn,1));
        end;

        % The largest full circle in original scaling
        % Distances from centre close the dedge distance from the edge

        edist=zeros(4,1);
        edist(1)=abs(nx-xcentre)-dedge;
        edist(2)=abs(ny-ycentre)-dedge;
        edist(3)=xcentre-dedge;
        edist(4)=ycentre-dedge;

        maxrad=min(edist);
        maxdm=2*maxrad;
        rectangle('Position',[xcentre-maxrad, ycentre-maxrad, maxdm, maxdm], ...
            'Curvature', [1,1], 'EdgeColor', 'blue', 'LineWidth', 2);

%       rr2=maxrad*maxrad;
        xo1=zeros(nnp,1);
        xo2=zeros(nnp,1);
        yo1=zeros(nnp,1);
        yo2=zeros(nnp,1);
        xi1=zeros(nnp,1);
        xi2=zeros(nnp,1);
        yi1=zeros(nnp,1);
        yi2=zeros(nnp,1);

        % Sections in upscaled version        
        for nn=1:nnp
            % Inner circle
            aqi=sl(nn)*sl(nn)+1;
            bqi=2*(sl(nn)*cc(nn)-sl(nn)*ycentre*scale-xcentre*scale);
            cqi=xcentre*xcentre*scale*scale+cc(nn)*cc(nn)-2*cc(nn)*ycentre*scale+...
                ycentre*ycentre*scale*scale-rad*rad*scale*scale;
            ddi=bqi*bqi-4*aqi*cqi;
            xi1(nn)=round((-bqi+sqrt(ddi))/(2*aqi));
            xi2(nn)=round((-bqi-sqrt(ddi))/(2*aqi));
            yi1(nn)=round(sl(nn)*xi1(nn)+cc(nn));
            yi2(nn)=round(sl(nn)*xi2(nn)+cc(nn));

            % Outer circle
            aqo=sl(nn)*sl(nn)+1;
            bqo=2*(sl(nn)*cc(nn)-sl(nn)*ycentre*scale-xcentre*scale);
            cqo=xcentre*xcentre*scale*scale+cc(nn)*cc(nn)-2*cc(nn)*ycentre*scale+...
                ycentre*ycentre*scale*scale-maxrad*maxrad*scale*scale;
            ddo=bqo*bqo-4*aqo*cqo;
            xo1(nn)=round((-bqo+sqrt(ddo))/(2*aqo));
            xo2(nn)=round((-bqo-sqrt(ddo))/(2*aqo));
            yo1(nn)=round(sl(nn)*xo1(nn)+cc(nn));
            yo2(nn)=round(sl(nn)*xo2(nn)+cc(nn));
        end;
        % -------------------------------------------------------
        % Optimise centre using centrosymmetric line profiles
        % -------------------------------------------------------
        % Upscaled calculations 

        nsample=1000*scale;

        lineprofile1=zeros(nsample,nnp);
        lineprofile2=zeros(nsample,nnp);

        if(maxshift > dedge)
            maxshift=dedge-1;
        end;
        ssum=zeros(2*maxshift+1,2*maxshift+1);

        % initial positions 
        xi1_o=xi1;
        xo1_o=xo1;
        xi2_o=xi2;
        xo2_o=xo2;
        cc_o=cc;
        
        % Initialise waitbar
        ProgBar = waitbar(0,'Please wait...','Name','Optimising centre',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
        setappdata(ProgBar,'canceling',0)
        full = length(-maxshift:maxshift);
        count = 0;
        
        for ii=-maxshift:maxshift
            count = count+1;
            for jj=-maxshift:maxshift
                xi1=xi1_o+jj*scale;
                xo1=xo1_o+jj*scale;
                xi2=xi2_o+jj*scale;
                xo2=xo2_o+jj*scale;
                cc=cc_o+ii*scale-jj*sl*scale;

                for nn=1:nnp
                    if (xi1(nn) < xo1(nn))
                        xx=xi1(nn):(xo1(nn)-xi1(nn))/(nsample-1):xo1(nn);
                    else
                        xx=xo1(nn):(xi1(nn)-xo1(nn))/(nsample-1):xi1(nn);
                    end;
                    yy=sl(nn)*xx+cc(nn);
                    % Downscale and get values
                    xxd=round(xx/scale);
                    yyd=round(yy/scale);

                    indx=sub2ind(size(dp),yyd,xxd);
                    lineprofile1(:,nn)=dp(indx);

                    if (xi2(nn) < xo2(nn))
                        xx=xi2(nn):(xo2(nn)-xi2(nn))/(nsample-1):xo2(nn);
                    else
                        xx=xo2(nn):(xi2(nn)-xo2(nn))/(nsample-1):xi2(nn);
                    end;
                    yy=sl(nn)*xx+cc(nn);
                    % Downscale and get values
                    xxd=round(xx/scale);
                    yyd=round(yy/scale);

                    indx=sub2ind(size(dp),yyd,xxd);
                    sindx=max(size(indx));
                    indxt=zeros(1,nsample);
                    indxt(1:1:sindx)=indx(sindx:-1:1);
                    lineprofile2(:,nn)=dp(indxt);

                    diff=lineprofile1(:,nn)-lineprofile2(:,nn);
                    if(sum(isnan(diff)) == 0) 
                        ssum(ii+maxshift+1,jj+maxshift+1)=ssum(ii+maxshift+1,jj+maxshift+1)+sum(diff.*diff);
                    end;
                end;                
            end;
            % Update waitbar
            % Check for Cancel button press
            if getappdata(ProgBar,'canceling')
                break
            end
            waitbar(count/full,ProgBar,'Please wait...');
        end;
        delete(ProgBar);
        
        [optval,optxys]=min(ssum(:));

        % Optimised centre
        [optxs,optys]=ind2sub(size(ssum),optxys);
        optxshift=optys-maxshift-1;
        optyshift=optxs-maxshift-1;

        xcentre_opt=xcentre+optxshift;
        ycentre_opt=ycentre+optyshift;

        % Plot the initial circles and centre
        rectangle('Position',[xcentre-rad, ycentre-rad, dm, dm], ...
            'Curvature', [1,1], 'EdgeColor', 'white', 'LineWidth', 2);

        rectangle('Position',[xcentre-maxrad, ycentre-maxrad, maxdm, maxdm], ...
            'Curvature', [1,1], 'EdgeColor', 'blue', 'LineWidth', 2);
        plot(xcentre, ycentre,  'r+', 'LineWidth', 1, 'MarkerSize', 20);        

        % Plot the optimised circles and centre
        rectangle('Position',[xcentre_opt-rad, ycentre_opt-rad, dm, dm], ...
            'Curvature', [1,1], 'EdgeColor', 'green', 'LineWidth', 2);

        rectangle('Position',[xcentre_opt-maxrad, ycentre_opt-maxrad, maxdm, maxdm], ...
            'Curvature', [1,1], 'EdgeColor', 'cyan', 'LineWidth', 2);

        plot(xcentre_opt, ycentre_opt,  'g+', 'LineWidth', 1, 'MarkerSize', 20);        

        % Optimised line profile positions
        xi1=xi1_o+optxshift*scale;
        xo1=xo1_o+optxshift*scale;
        xi2=xi2_o+optxshift*scale;
        xo2=xo2_o+optxshift*scale;
        cc=cc_o+optyshift*scale-optxshift*sl*scale;
        
        % -------------------------------------------------------
        % Plot the sum of optimised line profiles to test the fit
        % -------------------------------------------------------

        sum_lineprofile1=zeros(nsample,1);
        sum_lineprofile2=zeros(nsample,1);
        
        for nn=1:nnp
            if (xi1(nn) < xo1(nn))
                xx=xi1(nn):(xo1(nn)-xi1(nn))/(nsample-1):xo1(nn);
            else
                xx=xo1(nn):(xi1(nn)-xo1(nn))/(nsample-1):xi1(nn);
            end;
            yy=sl(nn)*xx+cc(nn);
            % Downscale and get values
            xxd=round(xx/scale);
            yyd=round(yy/scale);

            indx=sub2ind(size(dp),yyd,xxd);
            lineprofile1(:,nn)=dp(indx);

            if (xi2(nn) < xo2(nn))
                xx=xi2(nn):(xo2(nn)-xi2(nn))/(nsample-1):xo2(nn);
            else
                xx=xo2(nn):(xi2(nn)-xo2(nn))/(nsample-1):xi2(nn);
            end;
            yy=sl(nn)*xx+cc(nn);
            % Downscale and get values
            xxd=round(xx/scale);
            yyd=round(yy/scale);

            indx=sub2ind(size(dp),yyd,xxd);
            sindx=max(size(indx));
            indxt=zeros(1,nsample);
            indxt(1:1:sindx)=indx(sindx:-1:1);
            lineprofile2(:,nn)=dp(indxt);

            if(sum(isnan(lineprofile1(:,nn))+isnan(lineprofile2(:,nn))) == 0)
                sum_lineprofile1=sum_lineprofile1+lineprofile1(:,nn);
                sum_lineprofile2=sum_lineprofile2+lineprofile2(:,nn);
            end;
        end;
        
        figure('Name','Centrefinder fit','NumberTitle','off');
        plot(sum_lineprofile1);
        hold all;
        plot(sum_lineprofile2);
        plot(sum_lineprofile1-sum_lineprofile2);
        legend('Line profile 1','Line profile 2','Difference');

        % -------------------------------------------------------
        % Ask user to accept/reject optimisation
        % -------------------------------------------------------
        choice = questdlg('Do you want to accept the optimised centre?',...
            'Accept optimisation',...
            'Yes, accept and continue with optimisation',...
            'No, use the centre that I chose before',...
            'No, use the centre that I chose before');
        switch choice
            case 'Yes, accept and continue with optimisation'
                xcentre = xcentre_opt;
                ycentre = ycentre_opt;
                % --> continue with azav/azvar routine
            case 'No, use the centre that I chose before'
                % do nothing --> continue with azav/azvar routine
        end     
end
% ------------------------------------------------------- 
%% Ask user to choose directory to save files
folder = uigetdir(pname,'Select/create folder to save output');
addpath(folder);
handles.folder = folder;
guidata(hObject,handles)

%% Calculate azimuthal average and variance with known centre (xcentre, ycentre)

% Distances from corners to the centre of the diffraction pattern
cdist=zeros(4,1);
cdist(1)=sqrt((nx-xcentre)^2+(ny-ycentre)^2);
cdist(2)=sqrt((xcentre)^2+(ny-ycentre)^2);
cdist(3)=sqrt((nx-xcentre)^2+(ycentre)^2);
cdist(4)=sqrt((xcentre)^2+(ycentre)^2);

azavsize=round(max(cdist))+1;
azav=zeros(azavsize,1);
azvar=zeros(azavsize,1);
nazav=zeros(azavsize,1);

% Mean -------------------------------------------------
for xx=1:nx
    for yy=1:ny
        if (~isnan(dp(xx,yy))) 
            kk=sqrt((xx-ycentre)^2+(yy-xcentre)^2)+1;
            azav(round(kk))=azav(round(kk))+dp(xx,yy);
            nazav(round(kk))=nazav(round(kk))+1;
        end;
    end;
end;

% Variance ----------------------------------------------
for xx=1:nx
    for yy=1:ny
        if (~isnan(dp(xx,yy))) 
            kk=sqrt((xx-xcentre)^2+(yy-ycentre)^2)+1;
            azvar(round(kk))=azvar(round(kk))+(dp(xx,yy)-azav(round(kk)))^2;
        end;
    end;
end;

%% plot and write average and variance data

% Append data and plot filenames to DP filename
DPfname = handles.DPfname;
folder = handles.folder;
azav_name = sprintf('%s/%s_azav.txt',folder,DPfname);
handles.azav_name = azav_name;
azvar_name = sprintf('%s/%s_azvar.txt',folder,DPfname);
azav_plot = sprintf('%s/%s_azav',folder,DPfname);
azvar_plot = sprintf('%s/%s_azvar',folder,DPfname);

% Mean ----------------------------------
azav=azav./nazav;
handles.azav = azav;
save (azav_name,'azav','-ASCII');

% Variance ------------------------------
azvar=azvar./nazav;
handles.azvar = azvar;
save (azvar_name,'azvar','-ASCII');
% Normalized variance
% nazvar=azvar./(azav.*azav);
% handles.nazvar = nazvar;

%x-axis for plots ----------------------
pix_xax = linspace(1,azavsize,azavsize);
q_xax = pix_xax' * handles.ds*2*pi;

% Plot and save Azimuthal Average
figure('Name','Azimuthal Average','NumberTitle','off');
plot(q_xax,azav);
xlabel('q(Å^{-1})');
ylabel('Intensity');
print(gcf,azav_plot,'-dpng');
% savefig(azav_plot);

% Plot and save Azimuthal Variance 
figure('Name','Azimuthal Variance','NumberTitle','off');
plot(q_xax,azvar);
xlabel('q(Å^{-1})');
ylabel('Intensity');
print(gcf,azvar_plot,'-dpng');
% savefig(azvar_plot);

%% Prompt user to continue with RDF Analysis
msgbox({'Azimuthal Average and Variance data and plots';
    'have been saved in your preferred folder.';
    'Click Open next to "Choose average intensity data"';
    'and choose relevant "azav.txt" file for further analysis.'});

guidata(hObject,handles)

% ----------------------------------------------------------------------
% --- Executes on button press in Button_OpenData.
function Button_OpenData_Callback(hObject, eventdata, handles)
% hObject    handle to Button_OpenData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% choose data from input file (average azimuthal average data of diffraction pattern)
[filename,pathname] = uigetfile(...
    {'*.txt','Text files';'*.*','All files (*.*)';},...
    'Choose input data file');
addpath(pathname);
rehash toolboxcache;
dat = load(filename,'-ascii');
handles.dat = dat;

[pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>
handles.datfname = name;
handles.datpath = pathname;
guidata(hObject,handles)

%plot data
axes(handles.axes1);
plot(dat);
xlabel('Pixel Values');
ylabel('Pixel Intensity');

%total number of data points in file
points = length(dat);
%index number
num = linspace(1,points,points);
index = num.'; %transpose
handles.index = index;

guidata(hObject,handles)

% -----------------------------------------------------------------------
% ----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function DPSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DPSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DPSize_Callback(hObject, eventdata, handles)
% hObject    handle to DPSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DPSize as text
%        str2double(get(hObject,'String')) returns contents of DPSize as a double
% --- dpsize: center of DP
DPSize = str2double(get(hObject,'String'));
if isnan(DPSize)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.DPSize = DPSize;

guidata(hObject,handles)

% -----------------------------------------------------------------------
% ----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function d1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function d1_Callback(hObject, eventdata, handles)
% hObject    handle to d1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d1 as text
%        str2double(get(hObject,'String')) returns contents of d1 as a double
%--- d1: starting data point
d1 = str2double(get(hObject,'String'));
if isnan(d1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.d1 = d1;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function d2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function d2_Callback(hObject, eventdata, handles)
% hObject    handle to d2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d2 as text
%        str2double(get(hObject,'String')) returns contents of d2 as a double
% --- d2: ending data point
d2 = str2double(get(hObject,'String'));
if isnan(d2)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.d2 = d2;
guidata(hObject,handles)

% ---------------------------------------------------------------------
% -----------------------------------------------------------------------
% --- Executes on button press in Button_Plot.
function Button_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d1 = handles.d1;
d2 = handles.d2;

% beginning of data range
d1b = (d2-d1)/4 + d1;
% end of data range
d2a = d2 - (d2-d1)/4;

% new range of data points to be analysed
beginning = handles.dat(d1:d1b);
ending = handles.dat(d2a:d2);
% corresponding x axes (pixel values)
x1 = handles.index(d1:d1b);
x2 = handles.index(d2a:d2);

% plot new range of data points
axes(handles.axes2);
plot(x1,beginning);
xlabel('Pixel Values');
ylabel('Pixel Intensity');
legend('Beginning of data range');
legend boxoff;

axes(handles.axes3);
plot(x2,ending);
xlabel('Pixel Values');
ylabel('Pixel Intensity');
legend('End of data range');
legend boxoff;

% redefine selected data range
handles.I = handles.dat(d1:d2);
handles.x = handles.index(d1:d2);

guidata(hObject,handles)

% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% --- Executes on button press in Button_Iq.
function Button_Iq_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Iq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% convert pixel values to q
index = handles.x-handles.DPSize;
q = index*handles.ds*2*pi;
handles.q = q;

%plot I(q) vs q
axes(handles.axes4);
plot(q,handles.I,'b');
xlabel('q(Å^{-1})');
ylabel('I(q)');

% convert q to s
s = q/2/pi;
handles.s = s;

% s^2
s2 = s.^2;
handles.s2 = s2;

guidata(hObject,handles)

% -----------------------------------------------------------------------
% ----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function popup_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popup_param.
function popup_param_Callback(hObject, eventdata, handles)
% hObject    handle to popup_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_param contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_param

% --- choose which Parameterisation factors to use in fitting
param_val = get(hObject,'Value');
switch param_val
    case 3
        paramL = load('Lobato_2014.txt','-ascii');
        handles.paramL = paramL;
    otherwise
        paramK = load('Kirkland_2010.txt','-ascii'); % default
        handles.paramK = paramK;
end

handles.param_val = param_val;
guidata(hObject,handles)

% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function Element1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Element1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Element1.
function Element1_Callback(hObject, eventdata, handles)
% hObject    handle to Element1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Element1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Element1

% get selected element index / atomic number
val = get(hObject,'Value');
elem1 = val - 1;
handles.elem1 = elem1;
% get content string for output
contents = cellstr(get(hObject,'String'));
EName1 = contents{val};
handles.EName1 = EName1;

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Element2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Element2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Element2.
function Element2_Callback(hObject, eventdata, handles)
% hObject    handle to Element2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Element2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Element2

% get selected element index / atomic number
val = get(hObject,'Value');
elem2 = val - 1;
handles.elem2 = elem2;
% get content string for output
contents = cellstr(get(hObject,'String'));
EName2 = contents{val};
handles.EName2 = EName2;

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Element3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Element3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Element3.
function Element3_Callback(hObject, eventdata, handles)
% hObject    handle to Element3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Element3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Element3

% get selected element index / atomic number
val = get(hObject,'Value');
elem3 = val - 1;
handles.elem3 = elem3;
% get content string for output
contents = cellstr(get(hObject,'String'));
EName3 = contents{val};
handles.EName3 = EName3;

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Element4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Element4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Element4.
function Element4_Callback(hObject, eventdata, handles)
% hObject    handle to Element4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Element4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Element4

% get selected element index / atomic number
val = get(hObject,'Value');
elem4 = val - 1;
handles.elem4 = elem4;
% get content string for output
contents = cellstr(get(hObject,'String'));
EName4 = contents{val};
handles.EName4 = EName4;

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Element5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Element5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Element5.
function Element5_Callback(hObject, eventdata, handles)
% hObject    handle to Element5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Element5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Element5

% get selected element index / atomic number
val = get(hObject,'Value');
elem5 = val - 1;
handles.elem5 = elem5;
% get content string for output
contents = cellstr(get(hObject,'String'));
EName5 = contents{val};
handles.EName5 = EName5;

guidata(hObject,handles)

% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edit_e1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_e1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_e1 as text
%        str2double(get(hObject,'String')) returns contents of edit_e1 as a double
% --- Composition of element 1
e1 = str2double(get(hObject,'String'));
if isnan(e1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.e1 = e1;

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_e2_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to edit_e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_e2_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to edit_e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_e2 as text
%        str2double(get(hObject,'String')) returns contents of edit_e2 as a double
% --- Composition of element 2
e2 = str2double(get(hObject,'String'));
if isnan(e2)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.e2 = e2;

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_e3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_e3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_e3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_e3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_e3 as text
%        str2double(get(hObject,'String')) returns contents of edit_e3 as a double
% --- Composition of element 3
e3 = str2double(get(hObject,'String'));
if isnan(e3)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.e3 = e3;

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_e4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_e4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_e4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_e4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_e4 as text
%        str2double(get(hObject,'String')) returns contents of edit_e4 as a double
% --- Composition of element 4
e4 = str2double(get(hObject,'String'));
if isnan(e4)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.e4 = e4;

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_e5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_e5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_e5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_e5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_e5 as text
%        str2double(get(hObject,'String')) returns contents of edit_e5 as a double
% --- Composition of element 5
e5 = str2double(get(hObject,'String'));
if isnan(e5)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.e5 = e5;

guidata(hObject,handles)

% ----------------------------------------------------------------------
% -----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function N_Callback(hObject, eventdata, handles)
% hObject    handle to N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N as text
%        str2double(get(hObject,'String')) returns contents of N as a double
N = str2double(get(hObject,'String'));
if isnan(N)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.N = N;
% print value of N in static text
set(handles.text_N, 'String', handles.N);

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function dN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dN_Callback(hObject, eventdata, handles)
% hObject    handle to dN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dN as text
%        str2double(get(hObject,'String')) returns contents of dN as a double
dN = str2double(get(hObject,'String'));
if isnan(dN)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.dN = dN;

guidata(hObject,handles)

% --- Executes on button press in Nplus.
function Nplus_Callback(hObject, eventdata, handles)
% hObject    handle to Nplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.N = handles.N + handles.dN;
% print value of N in static text
set(handles.text_N, 'String', handles.N);

guidata(hObject,handles)

% --- Executes on button press in Nminus.
function Nminus_Callback(hObject, eventdata, handles)
% hObject    handle to Nminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.N = handles.N - handles.dN;
% print value of N in static text
set(handles.text_N, 'String', handles.N);

guidata(hObject,handles)

% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function q_fixed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q_fixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q_fixed_Callback(hObject, eventdata, handles)
% hObject    handle to q_fixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q_fixed as text
%        str2double(get(hObject,'String')) returns contents of q_fixed as a double

% --- q_fixed = value close to which user wants fitting to be done
q_fixed = str2double(get(hObject,'String'));
if isnan(q_fixed)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.q_fixed = q_fixed;
% print desired value of q in static text
% actual value (data point) will update when 'Fit Data' button is pushed
set(handles.text_q_fit, 'String', handles.q_fixed);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function dq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dq_Callback(hObject, eventdata, handles)
% hObject    handle to dq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dq as text
%        str2double(get(hObject,'String')) returns contents of dq as a double

% --- value to change q_fixed by
dq = str2double(get(hObject,'String'));
if isnan(dq)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.dq = dq;

guidata(hObject,handles)

% --- Executes on button press in qplus.
function qplus_Callback(hObject, eventdata, handles)
% hObject    handle to qplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- increase q_fixed by given dq value
handles.q_fixed = handles.q_fixed + handles.dq;
% print desired value of q in static text
% actual value (data point) will update when 'Fit Data' button is pushed
set(handles.text_q_fit, 'String', handles.q_fixed);

guidata(hObject,handles)

% --- Executes on button press in qminus.
function qminus_Callback(hObject, eventdata, handles)
% hObject    handle to qminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- decrease q_fixed by given dq value
handles.q_fixed = handles.q_fixed - handles.dq;
% print desired value of q in static text
% actual value (data point) will update when 'Fit Data' button is pushed
set(handles.text_q_fit, 'String', handles.q_fixed);

guidata(hObject,handles)

% -----------------------------------------------------------------------
% ----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function damping_CreateFcn(hObject, eventdata, handles)
% hObject    handle to damping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function damping_Callback(hObject, eventdata, handles)
% hObject    handle to damping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of damping as text
%        str2double(get(hObject,'String')) returns contents of damping as a double

% --- set damping factor (default 0.5)
damping = str2double(get(hObject,'String'));
if isnan(damping)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.damping = damping;
% print value of damping factor in static text
set(handles.text_damping, 'String', damping);

guidata(hObject,handles)

% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function rmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rmax_Callback(hObject, eventdata, handles)
% hObject    handle to rmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmax as text
%        str2double(get(hObject,'String')) returns contents of rmax as a double

% --- rmax sets the range of r (x-axis) to plot G(r)
rmax = str2double(get(hObject,'String'));
if isnan(rmax)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.rmax = rmax;

guidata(hObject,handles)

% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% --- Executes on button press in button_fit.
function button_fit_Callback(hObject, eventdata, handles)
% hObject    handle to button_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% find maximum q value smaller than q_fixed
tri = delaunayn(handles.q);
q_index = dsearchn(handles.q,tri,handles.q_fixed);
q_fit = handles.q(q_index);
% display q value at which fitting is done
set(handles.text_q_fit, 'String', q_fit);

handles.q_fit = q_fit;

guidata(hObject,handles)

% ---------------------------------------------------------------------
%% Compute fq_sq = <f(s)>^2
s2 = handles.s2;
elem1 = handles.elem1;
elem2 = handles.elem2;
elem3 = handles.elem3;
elem4 = handles.elem4;
elem5 = handles.elem5;
e1 = handles.e1;
e2 = handles.e2;
e3 = handles.e3;
e4 = handles.e4;
e5 = handles.e5;
% compute atomic ratio (composition)
e_tot = e1+e2+e3+e4+e5;
e_r1 = e1/e_tot;
e_r2 = e2/e_tot;
e_r3 = e3/e_tot;
e_r4 = e4/e_tot;
e_r5 = e5/e_tot;
handles.e_tot = e_tot;
handles.e_r1 = e_r1;
handles.e_r2 = e_r2;
handles.e_r3 = e_r3;
handles.e_r4 = e_r4;
handles.e_r5 = e_r5;
guidata(hObject,handles)

if handles.param_val == 3 % Lobato

    paramL = handles.paramL;
    paramL_1 = paramL(elem1,:);
    paramL_2 = paramL(elem2,:);
    paramL_3 = paramL(elem3,:);
    paramL_4 = paramL(elem4,:);
    paramL_5 = paramL(elem5,:);
    paramL_elem = [paramL_1;paramL_2;paramL_3;paramL_4;paramL_5];
    paramL_table = array2table(paramL_elem,'VariableNames',{'A1','A2','A3','A4','A5','B1','B2','B3','B4','B5'},'RowNames',{'elem1','elem2','elem3','elem4','elem5'});
    handles.paramL_table = paramL_table;
    
    A1_1 = paramL_table{'elem1','A1'};
    A2_1 = paramL_table{'elem1','A2'};
    A3_1 = paramL_table{'elem1','A3'};
    A4_1 = paramL_table{'elem1','A4'};
    A5_1 = paramL_table{'elem1','A5'};
    B1_1 = paramL_table{'elem1','B1'};
    B2_1 = paramL_table{'elem1','B2'};
    B3_1 = paramL_table{'elem1','B3'};
    B4_1 = paramL_table{'elem1','B4'};
    B5_1 = paramL_table{'elem1','B5'};

    f1 = ((s2*B1_1+1).^2).\(A1_1*(s2*B1_1+2))+((s2*B2_1+1).^2).\(A2_1*(s2*B2_1+2))+((s2*B3_1+1).^2).\(A3_1*(s2*B3_1+2))+((s2*B4_1+1).^2).\(A4_1*(s2*B4_1+2))+((s2*B5_1+1).^2).\(A5_1*(s2*B5_1+2));
    
    A1_2 = paramL_table{'elem2','A1'};
    A2_2 = paramL_table{'elem2','A2'};
    A3_2 = paramL_table{'elem2','A3'};
    A4_2 = paramL_table{'elem2','A4'};
    A5_2 = paramL_table{'elem2','A5'};
    B1_2 = paramL_table{'elem2','B1'};
    B2_2 = paramL_table{'elem2','B2'};
    B3_2 = paramL_table{'elem2','B3'};
    B4_2 = paramL_table{'elem2','B4'};
    B5_2 = paramL_table{'elem2','B5'};
    
    f2 = ((s2*B1_2+1).^2).\(A1_2*(s2*B1_2+2))+((s2*B2_2+1).^2).\(A2_2*(s2*B2_2+2))+((s2*B3_2+1).^2).\(A3_2*(s2*B3_2+2))+((s2*B4_2+1).^2).\(A4_2*(s2*B4_2+2))+((s2*B5_2+1).^2).\(A5_2*(s2*B5_2+2));

    A1_3 = paramL_table{'elem3','A1'};
    A2_3 = paramL_table{'elem3','A2'};
    A3_3 = paramL_table{'elem3','A3'};
    A4_3 = paramL_table{'elem3','A4'};
    A5_3 = paramL_table{'elem3','A5'};
    B1_3 = paramL_table{'elem3','B1'};
    B2_3 = paramL_table{'elem3','B2'};
    B3_3 = paramL_table{'elem3','B3'};
    B4_3 = paramL_table{'elem3','B4'};
    B5_3 = paramL_table{'elem3','B5'};
    
    f3 = ((s2*B1_3+1).^2).\(A1_3*(s2*B1_3+2))+((s2*B2_3+1).^2).\(A2_3*(s2*B2_3+2))+((s2*B3_3+1).^2).\(A3_3*(s2*B3_3+2))+((s2*B4_3+1).^2).\(A4_3*(s2*B4_3+2))+((s2*B5_3+1).^2).\(A5_3*(s2*B5_3+2));

    A1_4 = paramL_table{'elem4','A1'};
    A2_4 = paramL_table{'elem4','A2'};
    A3_4 = paramL_table{'elem4','A3'};
    A4_4 = paramL_table{'elem4','A4'};
    A5_4 = paramL_table{'elem4','A5'};
    B1_4 = paramL_table{'elem4','B1'};
    B2_4 = paramL_table{'elem4','B2'};
    B3_4 = paramL_table{'elem4','B3'};
    B4_4 = paramL_table{'elem4','B4'};
    B5_4 = paramL_table{'elem4','B5'};
    
    f4 = ((s2*B1_4+1).^2).\(A1_4*(s2*B1_4+2))+((s2*B2_4+1).^2).\(A2_4*(s2*B2_4+2))+((s2*B3_4+1).^2).\(A3_4*(s2*B3_4+2))+((s2*B4_4+1).^2).\(A4_4*(s2*B4_4+2))+((s2*B5_4+1).^2).\(A5_4*(s2*B5_4+2));
    
    A1_5 = paramL_table{'elem5','A1'};
    A2_5 = paramL_table{'elem5','A2'};
    A3_5 = paramL_table{'elem5','A3'};
    A4_5 = paramL_table{'elem5','A4'};
    A5_5 = paramL_table{'elem5','A5'};
    B1_5 = paramL_table{'elem5','B1'};
    B2_5 = paramL_table{'elem5','B2'};
    B3_5 = paramL_table{'elem5','B3'};
    B4_5 = paramL_table{'elem5','B4'};
    B5_5 = paramL_table{'elem5','B5'};

    f5 = ((s2*B1_5+1).^2).\(A1_5*(s2*B1_5+2))+((s2*B2_5+1).^2).\(A2_5*(s2*B2_5+2))+((s2*B3_5+1).^2).\(A3_5*(s2*B3_5+2))+((s2*B4_5+1).^2).\(A4_5*(s2*B4_5+2))+((s2*B5_5+1).^2).\(A5_5*(s2*B5_5+2));
    
else % Kirkland   
   
    paramK = handles.paramK;
    paramK_1 = paramK(elem1,:);
    paramK_2 = paramK(elem2,:);
    paramK_3 = paramK(elem3,:);
    paramK_4 = paramK(elem4,:);
    paramK_5 = paramK(elem5,:);
    paramK_elem = [paramK_1;paramK_2;paramK_3;paramK_4;paramK_5];
    paramK_table = array2table(paramK_elem,'VariableNames',{'a1','b1','a2','b2','a3','b3','c1','d1','c2','d2','c3','d3'},'RowNames',{'elem1','elem2','elem3','elem4','elem5'});
    handles.paramK_table = paramK_table;
    
    a1_1 = paramK_table{'elem1','a1'};
    a2_1 = paramK_table{'elem1','a2'};
    a3_1 = paramK_table{'elem1','a3'};
    b1_1 = paramK_table{'elem1','b1'};
    b2_1 = paramK_table{'elem1','b2'};
    b3_1 = paramK_table{'elem1','b3'};
    c1_1 = paramK_table{'elem1','c1'};
    c2_1 = paramK_table{'elem1','c2'};
    c3_1 = paramK_table{'elem1','c3'};
    d1_1 = paramK_table{'elem1','d1'};
    d2_1 = paramK_table{'elem1','d2'};
    d3_1 = paramK_table{'elem1','d3'};
    
    f1 = ((s2+b1_1).\a1_1)+((s2+b2_1).\a2_1)+((s2+b3_1).\a3_1)+(exp(-s2.*d1_1).*c1_1)+(exp(-s2.*d2_1).*c2_1)+(exp(-s2.*d3_1).*c3_1);
    
    a1_2 = paramK_table{'elem2','a1'};
    a2_2 = paramK_table{'elem2','a2'};
    a3_2 = paramK_table{'elem2','a3'};
    b1_2 = paramK_table{'elem2','b1'};
    b2_2 = paramK_table{'elem2','b2'};
    b3_2 = paramK_table{'elem2','b3'};
    c1_2 = paramK_table{'elem2','c1'};
    c2_2 = paramK_table{'elem2','c2'};
    c3_2 = paramK_table{'elem2','c3'};
    d1_2 = paramK_table{'elem2','d1'};
    d2_2 = paramK_table{'elem2','d2'};
    d3_2 = paramK_table{'elem2','d3'};
    
    f2 = ((s2+b1_2).\a1_2)+((s2+b2_2).\a2_2)+((s2+b3_2).\a3_2)+(exp(-s2.*d1_2).*c1_2)+(exp(-s2.*d2_2).*c2_2)+(exp(-s2.*d3_2).*c3_2);
        
    a1_3 = paramK_table{'elem3','a1'};
    a2_3 = paramK_table{'elem3','a2'};
    a3_3 = paramK_table{'elem3','a3'};
    b1_3 = paramK_table{'elem3','b1'};
    b2_3 = paramK_table{'elem3','b2'};
    b3_3 = paramK_table{'elem3','b3'};
    c1_3 = paramK_table{'elem3','c1'};
    c2_3 = paramK_table{'elem3','c2'};
    c3_3 = paramK_table{'elem3','c3'};
    d1_3 = paramK_table{'elem3','d1'};
    d2_3 = paramK_table{'elem3','d2'};
    d3_3 = paramK_table{'elem3','d3'};
    
    f3 = ((s2+b1_3).\a1_3)+((s2+b2_3).\a2_3)+((s2+b3_3).\a3_3)+(exp(-s2.*d1_3).*c1_3)+(exp(-s2.*d2_3).*c2_3)+(exp(-s2.*d3_3).*c3_3);
    
    a1_4 = paramK_table{'elem4','a1'};
    a2_4 = paramK_table{'elem4','a2'};
    a3_4 = paramK_table{'elem4','a3'};
    b1_4 = paramK_table{'elem4','b1'};
    b2_4 = paramK_table{'elem4','b2'};
    b3_4 = paramK_table{'elem4','b3'};
    c1_4 = paramK_table{'elem4','c1'};
    c2_4 = paramK_table{'elem4','c2'};
    c3_4 = paramK_table{'elem4','c3'};
    d1_4 = paramK_table{'elem4','d1'};
    d2_4 = paramK_table{'elem4','d2'};
    d3_4 = paramK_table{'elem4','d3'};
    
    f4 = ((s2+b1_4).\a1_4)+((s2+b2_4).\a2_4)+((s2+b3_4).\a3_4)+(exp(-s2.*d1_4).*c1_4)+(exp(-s2.*d2_4).*c2_4)+(exp(-s2.*d3_4).*c3_4);
    
    a1_5 = paramK_table{'elem5','a1'};
    a2_5 = paramK_table{'elem5','a2'};
    a3_5 = paramK_table{'elem5','a3'};
    b1_5 = paramK_table{'elem5','b1'};
    b2_5 = paramK_table{'elem5','b2'};
    b3_5 = paramK_table{'elem5','b3'};
    c1_5 = paramK_table{'elem5','c1'};
    c2_5 = paramK_table{'elem5','c2'};
    c3_5 = paramK_table{'elem5','c3'};
    d1_5 = paramK_table{'elem5','d1'};
    d2_5 = paramK_table{'elem5','d2'};
    d3_5 = paramK_table{'elem5','d3'};
    
    f5 = ((s2+b1_5).\a1_5)+((s2+b2_5).\a2_5)+((s2+b3_5).\a3_5)+(exp(-s2.*d1_5).*c1_5)+(exp(-s2.*d2_5).*c2_5)+(exp(-s2.*d3_5).*c3_5);
end
%%
fq = (f1.*e_r1) + (f2.*e_r2) + (f3.*e_r3) + (f4.*e_r4) + (f5.*e_r5);
fq_sq = fq.^2;

handles.fq_sq = fq_sq;
guidata(hObject,handles)
% -----------------------------------------------------------------------

%% Compute gq = <f^2(q)>
gq = (f1.^2*e_r1) + (f2.^2*e_r2) + (f3.^2*e_r3) + (f4.^2*e_r4) + (f5.^2*e_r5);
handles.gq = gq;
guidata(hObject,handles)
% -----------------------------------------------------------------------

% Compute fitting parameter C
f = find(handles.q == handles.q_fit);
C = handles.I(f) - handles.gq(f)*handles.N;

%% Compute fitting curve N*gq+C
fit = handles.N*handles.gq + C;
handles.fit = fit;

% Plot fitting curve
axes(handles.axes4);
plot(handles.q,handles.I,'b',handles.q,handles.fit,'r');
xlabel('q(Å^{-1})');
ylabel('I(q)');
legend('I(q)','I(q)_f_i_t_t_e_d');

% Plot magnified view
L = length(handles.q);
q2 = handles.q(L/2:L);
handles.q2 = q2;
handles.mag_dat = handles.I(L/2:L);
handles.mag_fit = handles.fit(L/2:L);

axes(handles.axes5);
plot(handles.q2,handles.mag_dat,'b',handles.q2,handles.mag_fit,'r');
xlabel('q(Å^{-1})');
ylabel('I(q)');
legend('I(q)','I(q)_f_i_t_t_e_d');

% goodness of fitting
R_sq = sum((handles.I - handles.fit).^2/handles.fit);
set(handles.text_R_sq, 'String', R_sq);
handles.R_sq = R_sq;

guidata(hObject,handles)
% ----------------------------------------------------------------------
q = handles.q;
I = handles.I;
ds = handles.ds;
fq_sq = handles.fq_sq;
N = handles.N;
fit = handles.fit; % fit = N*gq+C
s = handles.s;
s2 = handles.s2;
damping = handles.damping;

% Plot phiq and damped phiq
phiq = ((I - fit).*s)./(N*fq_sq);
handles.phiq = phiq;

phiq_damp = phiq.*exp(-s2.*damping);
handles.phiq_damp = phiq_damp;

axes(handles.axes6);
plot(q,phiq,'b',q,phiq_damp,'r');
xlabel('q(Å^{-1})');
ylabel('\phi(q)');
legend('\phi(q)','\phi(q)_d_a_m_p_e_d');
% plot reference line at phiq=zero
xlim = get(handles.axes6, 'xlim');
hold on
plot([xlim(1) xlim(2)], [0 0],'k'); 
hold off

% ----------------------------------------------------------------------
% Plot Gr
rmax = handles.rmax;
r = 0.01:0.01:rmax;
handles.r = r;

Gr = 8 * pi * phiq_damp'* sin(q*r) * ds ;
handles.Gr = Gr;

axes(handles.axes7);
plot(r,Gr);
xlabel('r(Å)');
ylabel('G(r)');
% plot reference line at Gr=zero
xlim = get(handles.axes7, 'xlim');
hold on
plot([xlim(1) xlim(2)], [0 0],'k'); 
hold off

guidata(hObject,handles)
% --------------------------------------------------------------------

function Export_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- export raw data of plots and fitting parameters 
% --- to single Excel file in Windows
[file,path] = uiputfile('Results.xls','Export results to Excel as');

% retrieve raw data
q = handles.q;
I = handles.I;
fit = handles.fit;
phiq = handles.phiq;
phiq_damp = handles.phiq_damp;
r = handles.r';
Gr = handles.Gr';

T1 = table(q,I,fit,phiq,phiq_damp,...
    'VariableNames',{'q' 'I' 'fit' 'phiq' 'phiq_damp'});
T2 = table(r,Gr,...
    'VariableNames',{'r' 'Gr'});

% retrieve fitting parameters
ds = handles.ds;
q_fixed = handles.q_fixed;
N = handles.N;
damping = handles.damping;
EName1 = handles.EName1;
EName2 = handles.EName2;
EName3 = handles.EName3;
EName4 = handles.EName4;
EName5 = handles.EName5;
e_r1 = handles.e_r1;
e_r2 = handles.e_r2;
e_r3 = handles.e_r3;
e_r4 = handles.e_r4;
e_r5 = handles.e_r5;

if handles.param_val == 3
    Parameterisation = 'Lobato';
else
    Parameterisation = 'Kirkland';
end

P1 = {'Factor','ds','qmax','N','damping'};
P2 = {Parameterisation,ds,q_fixed,N,damping};
P3 = {EName1,EName2,EName3,EName4,EName5};
P4 = {e_r1,e_r2,e_r3,e_r4,e_r5};

C = [P1;P2;P3;P4];
T3 = cell2table(C);

% export to single Excel file with 2 sheets
filename = sprintf('%s\\%s',path,file);
writetable(T3,filename,'WriteVariableNames',0);
writetable(T1,filename,'Sheet',2);
writetable(T2,filename,'Sheet',2,'Range','F1');
% --------------------------------------------------------------------
function Export_txt_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Export_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- export raw data of plots and fitting parameters to separate csv files
% --- (No Excel support in Mac)

% Ask user to choose directory to export csv files
folder = uigetdir('','Select folder to export CSV results to');

% retrieve raw data
q = handles.q;
I = handles.I;
fit = handles.fit;
phiq = handles.phiq;
phiq_damp = handles.phiq_damp;
r = handles.r';
Gr = handles.Gr';

T1 = table(q,I,fit,phiq,phiq_damp,...
    'VariableNames',{'q' 'I' 'fit' 'phiq' 'phiq_damp'});
T2 = table(r,Gr,...
    'VariableNames',{'r' 'Gr'});

% retrieve fitting parameters
ds = handles.ds;
q_fixed = handles.q_fixed;
N = handles.N;
damping = handles.damping;
EName1 = handles.EName1;
EName2 = handles.EName2;
EName3 = handles.EName3;
EName4 = handles.EName4;
EName5 = handles.EName5;
e_r1 = handles.e_r1;
e_r2 = handles.e_r2;
e_r3 = handles.e_r3;
e_r4 = handles.e_r4;
e_r5 = handles.e_r5;

if handles.param_val == 3
    Parameterisation = 'Lobato';
else
    Parameterisation = 'Kirkland';
end

P1 = {'Factor','ds','qmax','N','damping'};
P2 = {Parameterisation,ds,q_fixed,N,damping};
P3 = {EName1,EName2,EName3,EName4,EName5};
P4 = {e_r1,e_r2,e_r3,e_r4,e_r5};

C = [P1;P2;P3;P4];
T3 = cell2table(C);

% export to separate csv files
filename1 = sprintf('%s\\Results_q.csv',folder);
writetable(T1,filename1);
filename2 = sprintf('%s\\Results_r.csv',folder);
writetable(T2,filename2);
filename3 = sprintf('%s\\Parameters.csv',folder);
writetable(T3,filename3,'WriteVariableNames',0);

% --------------------------------------------------------------------
function Save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Ask user to choose directory to save Iq, Phiq and Gr plots as png
folder = uigetdir('','Select folder to save plots');

set(groot,'defaultFigurePaperPositionMode','auto');

% Iq
ax1 = handles.axes4;
ax1.Units = 'pixels';
pos = ax1.Position;
ti = ax1.TightInset;
rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
PlotI = getframe(ax1,rect);

figure('visible','off');
imshow(PlotI.cdata);
filename1 = sprintf('%s\\Plot_Iq',folder);
print(gcf,filename1,'-dpng');
close(gcf);

% Phiq
ax2 = handles.axes6;
ax2.Units = 'pixels';
pos = ax2.Position;
ti = ax2.TightInset;
rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
PlotPhi = getframe(ax2,rect);

figure('visible','off');
imshow(PlotPhi.cdata);
filename2 = sprintf('%s\\Plot_Phiq',folder);
print(gcf,filename2,'-dpng');
close(gcf);

% Gr
ax3 = handles.axes7;
ax3.Units = 'pixels';
pos = ax3.Position;
ti = ax3.TightInset;
rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
PlotGr = getframe(ax3,rect);

figure('visible','off');
imshow(PlotGr.cdata);
filename3 = sprintf('%s\\Plot_Gr',folder);
print(gcf,filename3,'-dpng');
close(gcf);
