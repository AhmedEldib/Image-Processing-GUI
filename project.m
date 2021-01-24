%% ------------------------------------------------------------------------
%% ------------Auto Generated functions--------------
function varargout = project(varargin)
% PROJECT MATLAB code for project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project

% Last Modified by GUIDE v2.5 05-Jan-2021 04:43:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_OpeningFcn, ...
                   'gui_OutputFcn',  @project_OutputFcn, ...
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


% --- Executes just before project is made visible.
function project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project (see VARARGIN)

% Choose default command line output for project
handles.output = hObject;

%intializing all image variables
handles.salt_img = [];
handles.periodic_img = [];
handles.img = [];
handles.salt_value = '0';
handles.median_size = '0';
handles.edge_value = '0';
handles.sobel_direction = '';
handles.edge_option = 1;
handles.remove_option = 1;

% Update handles structure
guidata(hObject, handles);

components_change_visibility(hObject, eventdata, handles, 'on', 'off')

reset_all_graphs(hObject, eventdata, handles)

% UIWAIT makes project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% ------------------------------------------------------------------------
%% -----------Extra Functions----------- 

%% Clear all Graphs
function reset_all_graphs(hObject, eventdata, handles)
    %resetting all graphs 
    axes(handles.Eq_img), cla reset
    axes(handles.Eq_hist), cla reset
    axes(handles.Og_hist), cla reset
    axes(handles.Og_img), cla reset
    axes(handles.restored_axes), cla reset
    
    %emptying all image variables
    handles.salt_img = [];
    handles.periodic_img = [];
    handles.img = [];
    handles.salt_value = '0';
    handles.median_size = '0';
    handles.edge_value = '0';
    handles.sobel_direction = '';
    guidata(hObject,handles)
 

%% Clear Right Side Graphs only
function reset_right_graphs(hObject, eventdata, handles)
    %resetting the 2 right graphs only 
    axes(handles.Eq_img), cla reset
    axes(handles.Eq_hist), cla reset   
    
    %emptying all image variables
    handles.salt_img = [];
    handles.periodic_img = [];
    guidata(hObject,handles)

    
%% Clear restored image and filtered fourier Graphs
function reset_restorde_graphs(hObject, eventdata, handles)
    %resetting the 2 right graphs only 
    axes(handles.Og_hist), cla reset
    axes(handles.restored_axes), cla reset   
    
    
%% Hide components will changing edge detection method    
function hide_edge_components(hObject, eventdata, handles, v1, v2)
    %Sobel components
    set(handles.sobel_option,'visible', v1)
    set(handles.sobel_label,'visible', v1)
    
    %Laplacian components
    set(handles.laplacian_label,'visible', v2)
    
    %reseting to xy Direction
    if isequal(v1, 'on')
        set(handles.xy_sobel_button, 'Value', 1);
        handles.sobel_direction = '';
    end
    
    %update gui
    guidata(hObject, handles);

   
%% Hide components when changing Noise addition method  
function components_change_visibility(hObject, eventdata, handles, v1, v2)
    %salt & pepper components
    set(handles.salt_text,'visible', v1)
    set(handles.median_text,'visible', v1)
    set(handles.salt_pepper,'visible', v1)
    set(handles.median_button,'visible', v1)
    
    %periodic components
    set(handles.periodic_text,'visible', v2)
    set(handles.x_axis_text,'visible', v2)
    set(handles.y_axis_text,'visible', v2)
    set(handles.periodic_remove_text,'visible', v2)
    set(handles.remove_periodic_button,'visible', v2)
    set(handles.add_periodic_button,'visible', v2)
    set(handles.remove_noise_list,'visible', v2)
    
    %reseting text boxes
    set(handles.salt_pepper_value, 'String', '0');
    set(handles.median_size_text, 'String', '0');
    handles.salt_value = '0';
    handles.median_size = '0';
    
    %update gui
    guidata(hObject, handles);
    
 
%% Return the fourier of a passed Image
function fourier = get_fourier(img, option)
    %transform to grey scale if rgb
    [rows, columns, color_channels] = size(img);
    if color_channels == 3 
        img = rgb2gray(img);
    end
    
    fourier = [];
    
    if isequal(option, 'log') % want log(absolute) fourier
        %Calculate the fourier of the passed img to show it
        img = fftshift(fft2(img));
        img = log(1 + abs(img));
        img_m = max(img(:)); 
        fourier = img/img_m;
    
    else %want absolute fourier only
        %Calculate the fourier of the passed img to show it
        img = fftshift(fft2(img));
        img = abs(img);
        img_m = max(img(:)); 
        fourier = img/img_m;
    end

  
%% Add periodic noise to the passed image and return it
function noisy_img = add_periodic_noise(img, nx, ny)
    %transform to grey scale if rgb
    [rows, columns, color_channels] = size(img);
    if color_channels == 3 
        img = rgb2gray(img);
    end
    
    %no input values
    if nx == 0 && ny == 0
        noisy_img = img;
        return
    end
    
    s = size(img);
    [x, y]= meshgrid(1:s(2),1:s(1));
    
    %intialize noise with zero for 2 directions
    fx = 0;
    fy = 0;
    
    %user entered number of cycles in X direction
    if nx > 0
        %x-direction
        Wx = max(max(x)); %Length of signal (x) (ncols)
        fx = ceil(nx)/Wx;
    end
    
    %user entered number of cycles in Y direction
    if ny > 0
        %y-direction
        Wx = max(max(y)); %Length of signal (y) (ncols)
        fy = ceil(ny)/Wx;
    end
    
    %calculate the noise wave
    pxy = sin(2*pi*fx*x + 2*pi*fy*y)+1; 
    
    %apply the noise wave to the image 
    noisy_img = mat2gray((im2double(img)+ pxy));
    
    
    
%% ------------------------------------------------------------------------    
%% -----------Toolbar------------------
    
%% -----------Toolbar Import Button-------------
function import_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    %setting browse to only select jpg, png, tif extensions
    [Filename, Pathname] = uigetfile('*', 'File Selector'); %'*.jpg;*.png;*.tif'
    
    % suppress warning (Input should be a string, character array, 
    % or cell array of character arrays. )
    warning('off','all')
    
    %getting image directory to read it
    img_dir = strcat(Pathname, Filename); 
    img = imread(img_dir);
    [rows, columns, color_channels] = size(img);
    if rows > 0 && columns > 0 && color_channels > 0
        %%set(handles.edit1, 'string', img_dir);

        %resetting all graphs before showing the image
        reset_all_graphs(hObject, eventdata, handles)

        %reseting text boxes
        set(handles.salt_pepper_value, 'String', '0');
        set(handles.median_size_text, 'String', '0');
        set(handles.edge_value_text, 'String', '0.0');
        set(handles.xy_sobel_button, 'Value', 1);

        %getting the image axes to show the imported image
        axes(handles.Og_img);
        %cla reset

        %plotting the image 
        imshow(img);
        impixelinfo
        title('Imported Image')
        h = gca;
        h.Visible = 'On'; %show x, y axis

        %saving the image to a global variable
        handles.img = img ;
        guidata(hObject,handles)
    else
        disp('corrupted image')
    end
catch
    warndlg('You Didn"t choose a valid image (PNG, JPG, TIF)')
end


%% -----------Toolbar Reset Button-------------
function reset_graph_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to reset_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reset_all_graphs(hObject, eventdata, handles)





%% ------------------------------------------------------------------------
%% --------- Buttons -----------

%% --- Executes on button press in Hist_list apply button.
function Equalization_button_Callback(hObject, eventdata, handles)
% hObject    handle to Equalization_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%getting the global image variable 
img = handles.img;

%check if there is an imported image or not
[x y] = size(img);
if [x y] == [0 0]
    warndlg('there is no imported image')
    return
end

%resetting graphs
axes(handles.Og_hist);
cla reset

%in both histogram or Equalization choices
if handles.hist_option == 1 || handles.hist_option == 2
    %printing the image histogram
    imhist(img);
    title('Imported Image Histogram')
    impixelinfo
    h = gca;
    h.Visible = 'On'; %show x, y axis
end

%if the user chose to apply histogram equalization
if handles.hist_option == 2
    %reset Graphs
    reset_right_graphs(hObject, eventdata, handles)
    
    %getting the equalized image axes to show the equalized image
    axes(handles.Eq_img);
    imshow(histeq(img)) %plotting the equalized image
    impixelinfo
    title('Equalized Image')
    h = gca;
    h.Visible = 'On'; %show x, y axis

    %getting the equalized image histogram axes 
    %to show the equalized image histogram
    axes(handles.Eq_hist);
    imhist(histeq(img))
    title('Equalized Image Histogram')
    impixelinfo
    h = gca;
    h.Visible = 'On'; %show x, y axis
end

%if the user chose to apply Fourier Transform
if handles.hist_option == 3
    %suppress warning (Displaying real part of complex input.)
    warning('off','all')
    
    %Get the fourier of the passed img
    fourier_img = get_fourier(img, 'log'); 
    imshow(fourier_img)
    
    title('Image Fourier Transform')
    impixelinfo
    h = gca;
    h.Visible = 'On'; %show x, y axis
end


%% --- Executes on button press in salt & pepper apply button.
function salt_pepper_Callback(hObject, eventdata, handles)
% hObject    handle to salt_pepper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%getting the global image variable 
img = handles.img;
noisy_img = img;

%check if there is an imported image or not
[x y] = size(img);
if [x y] == [0 0]
    warndlg('there is no imported image')
    return
end

%check if noise value is numerical
str = handles.salt_value;
if isempty(str2num(str))
    warndlg('Input must be decimal between 0 and 1');
    return
end 

%casting the input string into a decimal
noise_val = str2num(str);
s = size(noise_val); %get size of the decimal 

%check that there are no spaces in the string 
%since spaces create arrays with columns length > 1
if s(2) > 1
    warndlg('Input must be decimal between 0 and 1 with no spaces');
    return;
end

%check that the decimal is between 0 and 1
if noise_val < 0 || noise_val > 1
    warndlg('Input must be decimal between 0 and 1');
    return;
end

%check if image is already grey and not rgb
[rows, columns, color_channels] = size(img);
if color_channels == 3 
    noisy_img = rgb2gray(img);
end

%clearing the 2 right graphs
reset_right_graphs(hObject, eventdata, handles)

%getting the Noise image axes to show the Noisy image
axes(handles.Eq_img);
%applying noise with the entered values
noisy_img = imnoise(noisy_img,'salt & pepper',noise_val); 
imshow(noisy_img)
impixelinfo
title('Noisy Salt & Pepper Image')
h = gca;
h.Visible = 'On'; %show x, y axis

%saving the noisy image to a global variable
handles.salt_img = noisy_img ;
guidata(hObject,handles)


%% --- Executes on button press in median_button.
function median_button_Callback(hObject, eventdata, handles)
% hObject    handle to median_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%getting the global noisy image variable 
noisy_img = handles.salt_img;

if size(noisy_img) == [0 0]
    warndlg('there is no noisy image to filter')
    return
end

%check if kernel size is in right format
str = handles.median_size;
if isempty(strsplit(str,'x'))
    warndlg('Input must be in AxA format where A is an integer');
    return
end 

%spliting the input string at x to create an array with 2 values
kernel_size = strsplit(str,'x');
s = size(kernel_size); %get size of the array

%check that there are only 2 strings
if s(2) ~= 2 || s(1) ~= 1 
    warndlg('Input must be in AxA format where A is an integer');
    return;
end

%check that the 2 strings are numbers
kernel_size = cellfun(@str2num, kernel_size, 'UniformOutput', false);
check = cellfun(@isempty, kernel_size);

if check(1) == 1 || check(2) == 1
    warndlg('Input must be in AxA format where A is an integer');
    return
end 

%fix the values if the user entered negative or deciaml values
kernel_size = cellfun(@abs, kernel_size);
kernel_size = fix(kernel_size);

%check that the sizes are equal
if kernel_size(1) ~= kernel_size(2)
    warndlg('Matrix Size must be Equal');
    return;
end

%check that the sizes isn't zero
if kernel_size(1) == 0 || kernel_size(2) == 0
    warndlg('Matrix Size must be greater than 0x0');
    return;
end

%check that the user doesn't enter a very large value that might break the
%code
if kernel_size(1) > 100 || kernel_size(2) > 100
    warndlg('Matrix Size can"t be greater than 100x100 for processing');
    return;
end

%get the restored image axes 
axes(handles.Eq_hist);
%apply median filter to remove salt & pepper
imshow(medfilt2(noisy_img, kernel_size));
impixelinfo
title('Restored Image')
h = gca;
h.Visible = 'On'; %show x, y axis


%% --- Executes on button press in remove_periodic_button.
function remove_periodic_button_Callback(hObject, eventdata, handles)
% hObject    handle to remove_periodic_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%getting the global noisy image variable 
noisy_img = handles.periodic_img;

if size(noisy_img) == [0 0]
    warndlg('there is no noisy image to filter')
    return
end

noisy_abs_fourier = get_fourier(noisy_img, 'abs'); %get abs Fourier 
noisy_fourier = fftshift(fft2(noisy_img)); %get full fourier

%Any noisy pixel must be between 0.2 & 0.9 according to matlab site 
[x_noise, y_noise] = find(noisy_abs_fourier >= 0.2 & noisy_abs_fourier < 0.9);

if handles.remove_option == 1 %Band Reject

    [x, y] = size(noisy_img);
    [x, y] = meshgrid(-y/2 : y/2 - 1 , -x/2 : x/2 - 1); % A matrix of distances
    
    z = sqrt(x.^2 + y.^2);
    d = z(x_noise, y_noise); % distance of  spikes from centre 
    
    br = (z > d(1) + 1 | z < d(2) - 1); %% reject band of frequencies around spikes
    clean_img = noisy_fourier.*br;
    
    %getting the Filtered fourier Axes
    axes(handles.Og_hist);
    fl = log(1 + abs(clean_img));
    fm = max(fl(:));
    
    imshow(im2uint8(fl/fm)) %showing band rejected fourier
    title('Band Rejected Fourier')

elseif handles.remove_option == 2 %Notch Filter
    %make the rows and columns of the spikes zero:
    noisy_fourier(x_noise, :) = 0;
    noisy_fourier(: ,y_noise) = 0;
    
    clean_img = noisy_fourier;

    %getting the Filtered fourier Axes
    axes(handles.Og_hist);
    fl = log(1 + abs(clean_img));
    fm = max(fl(:));
    
    imshow(im2uint8(fl/fm)) %showing Notch Filter fourier
    title('Notch Filtered Fourier')

elseif handles.remove_option == 3 %Mask
    %get input pixels
    [x1, y1] = ginput(1);
    [x2, y2] = ginput(1);
    
    %create mask with image size
    logabsfft = log(abs(noisy_fourier));
    mask = ones(size(logabsfft));
    
    try
        %rounding clicked pixels to match the real pixel
        mask(round(y1), round(x1)) = 0; 
        mask(round(y2), round(x2)) = 0;
        
        clean_img = mask.*noisy_fourier; %remvoing noisy pixels
    catch
        warndlg("You must choose pixels inside the noisy fourier")
        return
    end
    

    %getting the Filtered fourier Axes
    axes(handles.Og_hist);
    fl = log(1 + abs(clean_img));
    fm = max(fl(:));
    
    imshow(im2uint8(fl/fm)) %showing Mask filtered fourier
    title('Mask Filtered Fourier')

end

impixelinfo
h = gca;
h.Visible = 'On'; %show x, y axis

% getting the inverse fourier of the filtered fourier
filteredImage = ifft2(ifftshift(clean_img));
ampFilteredImage = abs(filteredImage);
minValue = min(min(ampFilteredImage));
maxValue = max(max(ampFilteredImage));

%getting the Restored Image Axes
axes(handles.restored_axes);
imshow(ampFilteredImage, [minValue maxValue])
title('Restored Image')
impixelinfo
h = gca;
h.Visible = 'On'; %show x, y axis


%% --- Executes on button press in edge_button.
function edge_button_Callback(hObject, eventdata, handles)
% hObject    handle to edge_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img = handles.img;
edge_img = img;

%check if there is an imported image or not
[x, y] = size(img);
if [x y] == [0 0]
    warndlg('there is no imported image')
    return
end

%check if alpha/threshhold value is numerical
str = handles.edge_value;
if isempty(str2num(str))
    warndlg('Input must be decimal between 0 and 1');
    return
end 

%casting the input string into a decimal
edge_val = str2num(str);
s = size(edge_val); %get size of the decimal 

%check that there are no spaces in the string 
%since spaces create arrays with columns length > 1
if s(2) > 1
    warndlg('Input must be decimal between 0 and 1 with no spaces');
    return;
end

%check that the decimal is between 0 and 1
if edge_val < 0 || edge_val > 1
    warndlg('Input must be decimal between 0 and 1');
    return;
end

%check if image is already grey and not rgb
[rows, columns, color_channels] = size(img);
if color_channels == 3 
    edge_img = rgb2gray(img);
end

%getting the Edge Detection Axes
axes(handles.Og_hist);

if handles.edge_option == 1 %sobel
    %choosen sobel direction from radio buttons
    sobel_direction = handles.sobel_direction; 
    
    if isequal(sobel_direction, 'horizontal') 
        edge_img = edge(edge_img,'Sobel', edge_val, sobel_direction);
        
        imshow(edge_img)
        title('Sobel Edge Detection on Horizontal Edges')

    elseif isequal(sobel_direction, 'vertical')
        edge_img = edge(edge_img,'Sobel', edge_val, sobel_direction);
        
        imshow(edge_img)
        title('Sobel Edge Detection on Vertical Edges')

    else
        edge_img = edge(edge_img,'Sobel', edge_val, 'both');
        
        imshow(edge_img)
        title('Sobel Edge Detection on All Edges')
    end

    
    
elseif handles.edge_option == 2 %Laplacian
    lap = fspecial('laplacian', edge_val);
    edge_img = filter2(lap, edge_img);
    
    imshow(edge_img)
    title('Laplacian Edge Detection Image')
end

impixelinfo
h = gca;
h.Visible = 'On'; %show x, y axis


%% --- Executes on button press in add_periodic_button.
function add_periodic_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_periodic_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reset_restorde_graphs(hObject, eventdata, handles)

%getting the global image variable 
img = handles.img;
noisy_img = img;

%check if there is an imported image or not
[x y] = size(img);
if [x y] == [0 0]
    warndlg('there is no imported image')
    return
end

%check if noise value is numerical
str1 = handles.salt_value; %X-axis cycles
str2 = handles.median_size; %Y-axis cycles

if isempty(str2num(str1)) || isempty(str2num(str2))
    warndlg('Input must be greater than or equal Zero');
    return
end 

%casting the input string into an integer
noise_val_x = str2num(str1);
noise_val_y = str2num(str2);

s1 = size(noise_val_x); %get size of the integer
s2 = size(noise_val_y); %get size of the integer 

%check that there are no spaces in the string 
%since spaces create arrays with columns length > 1
if s1(2) > 1 || s2(2) > 1
    warndlg('Input must be greater than or equal Zero with no spaces');
    return;
end

%check that the Number is Positive integer of zero
if noise_val_x < 0 || noise_val_y < 0
    warndlg('Input must be greater than or equal Zero');
    return;
end

%check that the Number isn't very large or it might break the code
if noise_val_x > 1000 || noise_val_y > 1000
    warndlg('Input can"t be greater than 1000 cycles for processing');
    return;
end

%check if image is already grey and not rgb
[rows, columns, color_channels] = size(img);
if color_channels == 3 
    noisy_img = rgb2gray(img);
end

%clearing the 2 right graphs
reset_right_graphs(hObject, eventdata, handles)

%getting the Noise image axes to show the Noisy image
axes(handles.Eq_img);
%applying noise with the entered values
noisy_img = add_periodic_noise(img, noise_val_y, noise_val_x); 
imshow(noisy_img)
impixelinfo
title('Periodic Noise Image')
h = gca;
h.Visible = 'On'; %show x, y axis

%getting the Noisy image Fourier axes 
%to show the noisy image Fourier
axes(handles.Eq_hist);

%suppress warning (Displaying real part of complex input.)
warning('off','all')

%calculating noisy image fourier
noisy_fourier = get_fourier(noisy_img, 'log');
imshow(noisy_fourier)
title('Noisy Image Fourier')
impixelinfo
h = gca;
h.Visible = 'On'; %show x, y axis

%saving the noisy image and its fourier to a global variables
handles.periodic_img = noisy_img ;
handles.periodic_fourier = noisy_fourier;
guidata(hObject,handles)




%% ------------------------------------------------------------------------
%% --------- LISTS -----------

%% --- Executes on selection change in hist_list.
function hist_list_Callback(hObject, eventdata, handles)
% hObject    handle to hist_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hist_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hist_list

handles = guidata(hObject);  % Updating handles
switch get(handles.hist_list,'Value')   %on user choosing from the drop down menu
  case 1
    handles.hist_option = 1;
    guidata(hObject, handles);  % case 1: user wants image histogram only
  case 2
    handles.hist_option = 2;
    guidata(hObject, handles);  % case 2: user wants histogram equalization
  case 3
    handles.hist_option = 3;
    guidata(hObject, handles);  % case 3: user wants Fourier Transform
  otherwise
end 


%% --- Executes during object creation, after setting all properties.
function hist_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hist_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles = guidata(hObject);  % Updating handles
handles.hist_option = 1;
guidata(hObject, handles);  % Updating handles


%% --- Executes on selection change in noise_list.
function noise_list_Callback(hObject, eventdata, handles)
% hObject    handle to noise_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns noise_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noise_list

handles = guidata(hObject);  % Updating handles
switch get(handles.noise_list,'Value')   %on user choosing from the drop down menu
  case 1 % case 1: user wants salt & pepper noise
    %only (salt & pepper / median filter) appear
    
    components_change_visibility(hObject, eventdata, handles, 'on', 'off') 
    
  case 2 % case 2: user wants periodic
    %only (periodic noise / 3 methods of removal) appear
    
    components_change_visibility(hObject, eventdata, handles, 'off', 'on') 
    
  otherwise
end 
  

%% --- Executes during object creation, after setting all properties.
function noise_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in remove_noise_list.
function remove_noise_list_Callback(hObject, eventdata, handles)
% hObject    handle to remove_noise_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns remove_noise_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from remove_noise_list

handles = guidata(hObject);  % Updating handles
switch get(handles.remove_noise_list,'Value')   %on user choosing from the drop down menu
  case 1 % case 1: user wants Band Reject
    handles.remove_option = 1;
    
  case 2 % case 2: user wants Notch Filter
    handles.remove_option = 2;
    
  case 3 % case 3: user wants Mask
    handles.remove_option = 3;
    
  otherwise
end 

guidata(hObject, handles);
 

%% --- Executes during object creation, after setting all properties.
function remove_noise_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_noise_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in edge_list.
function edge_list_Callback(hObject, eventdata, handles)
% hObject    handle to edge_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edge_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edge_list
handles = guidata(hObject);  % Updating handles
switch get(handles.edge_list,'Value')   %on user choosing from the drop down menu
  case 1 % case 1: user wants Sobel 
    hide_edge_components(hObject, eventdata, handles, 'on', 'off') 
    handles.edge_option = 1;

  case 2 % case 2: user wants Laplacian
    hide_edge_components(hObject, eventdata, handles, 'off', 'on')
     handles.edge_option = 2;

  otherwise
end 

guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties.
function edge_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edge_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ------------------------------------------------------------------------
%% --------- Text Boxes -----------
%% salt & pepper noise value text box 
function salt_pepper_value_Callback(hObject, eventdata, handles)
% hObject    handle to salt_pepper_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of salt_pepper_value as text
%        str2double(get(hObject,'String')) returns contents of salt_pepper_value as a double

%on text change set the value to a global variable
handles.salt_value = get(hObject,'String');
guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties.
function salt_pepper_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to salt_pepper_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%on text change set the value to a global variable
handles.salt_value = get(hObject,'String');
guidata(hObject, handles);


%% median filter size text box 
function median_size_text_Callback(hObject, eventdata, handles)
% hObject    handle to median_size_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of median_size_text as text
%        str2double(get(hObject,'String')) returns contents of median_size_text as a double

%on text change set the value to a global variable
handles.median_size = get(hObject,'String');
guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties.
function median_size_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to median_size_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%on text change set the value to a global variable
handles.median_size = get(hObject,'String');
guidata(hObject, handles);


%% edge detection parameter text box 
function edge_value_text_Callback(hObject, eventdata, handles)
% hObject    handle to edge_value_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edge_value_text as text
%        str2double(get(hObject,'String')) returns contents of edge_value_text as a double

%on text change set the value to a global variable
handles.edge_value = get(hObject,'String');
guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties.
function edge_value_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edge_value_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%on text change set the value to a global variable
handles.edge_value = get(hObject,'String');
guidata(hObject, handles);


%% --------------Radio Buttons-------------------
%% --- Executes when selected object is changed in sobel_option.
function sobel_option_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in sobel_option 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the values of the radio buttons in this group.
r1 = get(handles.x_sobel_button, 'Value');
r2 = get(handles.y_sobel_button, 'Value');

handles.sobel_direction = '';

if r1 == 1
    handles.sobel_direction = 'horizontal';

elseif r2 == 1
    handles.sobel_direction = 'vertical';
else
end

guidata(hObject, handles);
