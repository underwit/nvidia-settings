changequote([[[, ]]])dnl
dnl Solaris man chokes on three-letter macros.
ifelse(__BUILD_OS__,SunOS,[[[define(__URL__,UR)]]],[[[define(__URL__,URL)]]])dnl
.\" Copyright (C) 2006 NVIDIA Corporation.
__HEADER__
.\" Define the .__URL__ macro and then override it with the www.tmac package if it
.\" exists.
.de __URL__
\\$2 \(la \\$1 \(ra\\$3
..
.if \n[.g] .mso www.tmac
.TH nvidia\-settings 1 2006-03-17 "nvidia\-settings 1.0"
.SH NAME
nvidia\-settings \- configure the NVIDIA graphics driver
.SH SYNOPSIS
.BI "nvidia\-settings [" "options" "]"
.br
.BI "nvidia\-settings [" "options" "] \-\-no\-config"
.br
.BI "nvidia\-settings [" "options" "] \-\-load\-config\-only"
.br
.BI "nvidia\-settings [" "options" "] {\-\-query=" attr " | \-\-assign=" attr = value "} ..."
.br
.BI "nvidia\-settings [" "options" "] \-\-glxinfo"
.PP
Options:
.BI "[-vh] [\-\-config=" configfile "] [\-c " ctrl-display "]"
.br
.I "         \fB[\-\-verbose=\fP{\fIerrors \fP|\fI warnings \fP|\fI all\fP}\fB]"
.br
.I "         \fB[\-\-describe=\fP{\fIall \fP|\fI list \fP|\fI attribute_name\fP}\fB]"
.PP
.I attr
has the form:
.ti +5
.IB DISPLAY / attribute_name [ display_devices ]
.SH DESCRIPTION
The
.B nvidia\-settings
utility is a tool for configuring the NVIDIA graphics driver.
It operates by communicating with the NVIDIA X driver, querying and updating state as appropriate.
This communication is done with the NV-CONTROL X extension.
.PP
Values such as brightness and gamma, XVideo attributes, temperature, and OpenGL settings can be queried and configured via
.B nvidia\-settings.
.PP
When
.B nvidia\-settings
starts, it reads the current settings from its configuration file and sends those settings to the X server.
Then, it displays a graphical user interface (GUI) for configuring the current settings.
When
.B nvidia\-settings
exits, it queries the current settings from the X server and saves them to the configuration file.
.SH OPTIONS
.TP
.B \-v, \-\-version
Print the
.B nvidia\-settings
version and exit.
.TP
.B \-h, \-\-help
Print usage information and exit.
.TP
.BI "\-\-config=" config
Use the configuration file
.I config
rather than the default
.I ~/.nvidia\-settings\-rc
.TP
.BI "\-c, \-\-ctrl\-display=" ctrl-display
Control the specified X display.
If this option is not given, then
.B nvidia\-settings
will control the display specifed by
.B \-\-display.
If that is not given, then the
.I $DISPLAY
environment variable is used.
.TP
.B \-n, \-\-no\-config
Do not load the configuration file.
This mode of operation is useful if
.B nvidia\-settings
has difficulties starting due to problems with applying settings in the configuration file.
.TP
.B \-l, \-\-load\-config\-only
Load the configuration file, send the values specified therein to the X server, and exit.
This mode of operation is useful to place in your .xinitrc file, for example.
.TP
.B \-r, \-\-rewrite\-config\-file
Write the current X server configuration to the configuration file, and exit without starting 
a grpahical user interface.See Examples section.
.TP
.BI "\-V, \-\-verbose=" verbosity
Controls how much information is printed.
By default, the verbosity is 
.B errors
and only error messages are printed.
.br

.I verbosity
can be one of the following values:
.ti +5
.B errors
- Print errors.
.ti +5
.B warnings
- Print errors and warnings.
.ti +5
.B all
- Print errors, warnings, and other information.
.TP
.BI "\-a, \-\-assign=" assign
The
.I assign
argument to the
.B \-\-assign
commandline option is of the form:
.nf

        {DISPLAY}/{attribute name}[{display devices}]={value}

.fi
This assigns the attribute {attribute name} to the value {value} on the X Display {DISPLAY}.
{DISPLAY} follows the usual {host}:{display}.{screen} syntax of the DISPLAY environment variable and is optional; when it is not specified, then it is implied following the same rule as the
.B \-\-ctrl\-display
option.
If the X screen is not specified, then the assignment is made to all X screens.
Note that the '/' is only required when {DISPLAY} is present.
.sp
.br
{DISPLAY} can additionally include a target specification to direct an assignment to something other than an X screen.
A target specification is contained within brackets and consists of a target type name, a colon, and the target id.
The target type name can be one of
.B screen,
.B gpu,
or
.B framelock;
the target id is the index into the list of targets (for that target type).
The target specification can be used in {DISPLAY} wherever an X screen can be used, following the syntax {host}:{display}[{target_type}:{target_id}].
See the output of
.nf

        nvidia-settings --query all

.fi
for information on which target types can be used with which attributes.
See the output of
.nf

        nvidia-settings -q screens -q gpus -q framelocks

.fi
for lists of targets for each target type.
.br
.sp
The [{display devices}] portion is also optional; if it is not specified, then the attribute is assigned to all display devices.
.br
.sp
Some examples:
.nf

        -a FSAA=5
        -a localhost:0.0/DigitalVibrance[CRT-0]=0
        --assign="SyncToVBlank=1"
        -a [gpu:0]/DigitalVibrance[DFP-1]=63

.fi
.TP
.BI "\-q, \-\-query=" query
The
.I query
argument to the
.B \-\-query
commandline option is of the form:
.nf

        {DISPLAY}/{attribute name}[{display devices}]

.fi
This queries the current value of the attribute {attribute name} on the X Display {DISPLAY}.
The syntax is the same as that for the
.B \-\-assign
option, without
.B ={value}.
Specify
.B \-q screens,
.B \-q gpus,
or
.B \-q framelocks
to query a list of X screens, GPUs, or Frame Lock devices, respectively, that are present on the X Display {DISPLAY}.
Specify
.B \-q all
to query all attributes.
.TP
.B \-g, \-\-glxinfo
Print GLX Information for the X display and exit.
.TP
.B \-e, \-\-describe
Prints information about a particular attribute.  Specify 'all' to list the descriptions of all attributes.  Specify 'list' to list the attribute names without a descriptions.
.SH "USER GUIDE"
.SS Contents
1.	Layout of the nvidia\-settings GUI
.br
2.	How OpenGL Interacts with nvidia\-settings
.br
3.	Loading Settings Automatically
.br
4.	Commandline Interface
.br
5.	X Display Names in the Config File
.br
6.	Connecting to Remote X Servers
.br
7.	Licensing
.br
8.	TODO
.br
.SS 1. Layout of the nvidia\-settings GUI
The
.B nvidia\-settings
GUI is organized with a list of different categories on the left side.
Only one entry in the list can be selected at once, and the selected category controls which "page" is displayed on the right side of the
.B nvidia\-settings
GUI.
.PP
The category list is organized in a tree: each X screen contains the relevant subcategories beneath it.
Similarly, the Display Devices category for a screen contains all the enabled display devices beneath it.
Besides each X screen, the other top level category is "nvidia\-settings Configuration", which configures behavior of the
.B nvidia\-settings
application itself.
.PP
Along the bottom of the
.B nvidia\-settings
GUI, from left to right, is:
.TP
1)
a status bar which indicates the most recently altered option;
.TP
2)
a Help button that toggles the display of a help window which provides a detailed explanation of the available options in the current page; and
.TP
3)
a Quit button to exit
.B nvidia\-settings.
.PP
Most options throughout
.B nvidia\-settings
are applied immediately.
Notable exceptions are OpenGL options which are only read by OpenGL when an OpenGL application starts.
.PP
Details about the options on each page of
.B nvidia\-settings
are available in the help window.
.SS 2. How OpenGL Interacts with nvidia\-settings
.PP
When an OpenGL application starts, it downloads the current values from the X driver, and then reads the environment (see
.I APPENDIX E: OPENGL ENVIRONMENT VARIABLE SETTINGS
in the README).
Settings from the X server override OpenGL's default values, and settings from the environment override values from the X server.
.PP
For example, by default OpenGL uses the FSAA setting requested by the application (normally, applications do not request any FSAA).
An FSAA setting specified in
.B nvidia\-settings
would override the OpenGL application's request.
Similarly, the
.B __GL_FSAA_MODE
environment variable will override the application's FSAA setting, as well as any FSAA setting specified in
.B nvidia\-settings.
.PP
Note that an OpenGL application only retrieves settings from the X server when
it starts, so if you make a change to an OpenGL value in
.B nvidia\-settings,
it will only apply to OpenGL applications which are started after that point in time.
.SS 3. Loading Settings Automatically
The NVIDIA X driver does not preserve values set with
.B nvidia\-settings
between runs of the X server (or even between logging in and logging out of X, with
.BR xdm (1),
.B gdm,
or
.B kdm
).
This is intentional, because different users may have different preferences, thus these settings are stored on a per-user basis in a configuration file stored in the user's home directory.
.PP
The configuration file is named
.IR ~/.nvidia\-settings\-rc .
You can specify a different configuration file name with the
.B \-\-config
commandline option.
.PP
After you have run
.B nvidia\-settings
once and have generated a configuration file, you can then run:
.sp
.ti +5
nvidia\-settings \-\-load\-config\-only
.sp
at any time in the future to upload these settings to the X server again.
For example, you might place the above command in your
.I ~/.xinitrc
file so that your settings are applied automatically when you log in to X.
.PP
Your
.I .xinitrc
file, which controls what X applications should be started when you log into X (or startx), might look something like this:
.nf

     nvidia-settings --load-config-only &
     xterm &
     evilwm

.fi
or:
.nf

     nvidia-settings --load-config-only &
     gnome-session

.fi
If you do not already have an
.I ~/.xinitrc
file, then chances are that
.BR xinit (1)
is using a system-wide xinitrc file.
This system wide file is typically here:
.nf

     /etc/X11/xinit/xinitrc

.fi
To use it, but also have
.B nvidia\-settings
upload your settings, you could create an
.I ~/.xinitrc
with the contents:
.nf

     nvidia-settings --load-config-only &
     . /etc/X11/xinit/xinitrc

.fi
System administrators may choose to place the
.B nvidia\-settings
load command directly in the system xinitrc script.
.PP
Please see the
.BR xinit (1)
man page for further details of configuring your
.I ~/.xinitrc
file.
.SS 4. Commandline Interface
.B nvidia\-settings
has a rich commandline interface: all attributes that can be manipulated with the GUI can also be queried and set from the command line.
The commandline syntax for querying and assigning attributes matches that of the 
.I .nvidia\-settings\-rc
configuration file.
.PP
The
.B \-\-query
option can be used to query the current value of attributes.
This will also report the valid values for the attribute.
You can run
.B nvidia\-settings \-\-query all
for a complete list of available attributes, what the current value is, what values are valid for the attribute, and through which target types (e.g., X screens, GPUs) the attributes can be addressed.
Additionally, individual attributes may be specified like this:
.nf

        nvidia-settings --query CursorShadow

.fi
Attributes that may differ per display device (for example, DigitalVibrance can be set independently on each display device when in TwinView) can be appended with a "display device name" within brackets; e.g.:
.nf

        nvidia-settings --query DigitalVibrance[CRT-0]

.fi
If an attribute is display device specific, but the query does not specify a display device, then the attribute value for all display devices will be queried.
.PP
An attribute name may be prepended with an X Display name and a forward slash
to indicate a different X Display; e.g.:
.nf

        nvidia-settings --query localhost:0.0/DigitalVibrance[DFP-1]

.fi
An attribute name may also just be prepended with the screen number and a forward slash:
.nf

        nvidia-settings --query 0/DigitalVibrance[DFP-1]

.fi
in which case the default X Display will be used, but you can indicate to which X screen to direct the query (if your X server has multiple X screens).
If no X screen is specified, then the attribute value will be queried for all X screens.
.PP
Attributes can be addressed through "target types".
A target type indicates the object that is queried when you query an attribute.
The default target type is an X screen, but other possible target types are GPUs and Frame Lock devices.
.PP
Target types give you different granularities with which to perform queries and assignments.
Since X screens can span multiple GPUs (in the case of Xinerama, or SLI), and multiple X screens can exist on the same GPU, it is sometimes useful to address attributes by GPU rather than X screen.
.PP
A target specification is contained within brackets and consists of a target type name, a colon, and the target id.
The target type name can be one of
.B screen,
.B gpu,
or
.B framelock;
the target id is the index into the list of targets (for that target type).
Target specifications can be used wherever an X screen is used in query and assignment commands; the target specification can be used either by itself on the left side of the forward slash, or as part of an X Display name.
.PP
For example, the following queries address X screen 0 on the localhost:
.nf

        nvidia-settings --query 0/VideoRam
        nvidia-settings --query localhost:0.0/VideoRam
        nvidia-settings --query [screen:0]/VideoRam
        nvidia-settings --query localhost:0[screen:0]/VideoRam

.fi
To address GPU 0 instead, you can use either of:
.nf

        nvidia-settings --query [gpu:0]/VideoRam
        nvidia-settings --query localhost:0[gpu:0]/VideoRam

.fi
See the output of
.nf

        nvidia-settings --query all

.fi
for what targets types can be used with each attribute.
See the output of
.nf

        nvidia-settings --query screens --query gpus --query framelocks

.fi
for lists of targets for each target type.
.PP
The
.B \-\-assign
option can be used to assign a new value to an attribute.
The valid values for an attribute are reported when the attribute is queried.
The syntax for
.B \-\-assign
is the same as
.B \-\-query,
with the additional requirement that assignments also have an equal sign and the new value.
For example:
.nf

        nvidia-settings --assign FSAA=2
        nvidia-settings --assign 0/DigitalVibrance[CRT-1]=9
        nvidia-settings --assign [gpu:0]/DigitalVibrance=0
.fi
.PP
Multiple queries and assignments may be specified on the commandline for a single invocation of
.B nvidia\-settings.
.PP
If either the
.B \-\-query
or
.B \-\-assign
options are passed to
.B nvidia\-settings,
the GUI will not be presented, and
.B nvidia\-settings
will exit after processing the assignments and/or queries.
.SS 5. X Display Names in the Config File
In the Commandline Interface section above, it was noted that you can specify an attribute without any X Display qualifiers, with only an X screen qualifier, or with a full X Display name.
For example:
.nf

        nvidia-settings --query FSAA
        nvidia-settings --query 0/FSAA
        nvidia-settings --query stravinsky.nvidia.com:0/FSAA

.fi
In the first two cases, the default X Display will be used, in the second case, the screen from the default X Display can be overridden, and in the third case, the entire default X Display can be overridden.
.PP
The same possibilities are available in the
.I ~/.nvidia\-settings-rc
configuration file.
.PP
For example, in a computer lab environment, you might log into any of multiple
workstations, and your home directory is NFS mounted to each workstation.
In such a situation, you might want your
.I ~/.nvidia\-settings-rc
file to be applicable to all the workstations.
Therefore, you would not want your config file to qualify each attribute with an X Display Name.
Leave the "Include X Display Names in the Config File" option unchecked on the
.B nvidia\-settings
Configuration page (this is the default).
.PP
There may be cases when you do want attributes in the config file to be qualified with the X Display name.
If you know what you are doing and want config file attributes to be qualified with an X Display, check the "Include X Display Names in the Config File" option on the
.B nvidia\-settings
Configuration page.
.PP
In the typical home user environment where your home directory is local to one computer and you are only configuring one X Display, then it does not matter whether each attribute setting is qualified with an X Display Name.
.SS 6. Connecting to Remote X Servers
.B nvidia\-settings
is an X client, but uses two separate X connections: one to display the GUI, and another to communicate the NV-CONTROL requests.
These two X connections do not need to be to the same X server.
For example, you might run
.B nvidia\-settings
on the computer stravinsky.nvidia.com, export the display to the computer bartok.nvidia.com, but be configuring the X server on the computer schoenberg.nvidia.com:
.nf

        nvidia-settings --display=bartok.nvidia.com:0 \\
            --ctrl-display=schoenberg.nvidia.com:0

.fi
If
.B \-\-ctrl-display
is not specified, then the X Display to control is what
.B \-\-display
indicates.
If
.B \-\-display
is also not specified, then the
.I $DISPLAY
environment variable is used.
.PP
Note, however, that you will need to have X permissions configured such that you can establish an X connection from the computer on which you are running
.B nvidia\-settings
(stravinsky.nvidia.com) to the computer where you are displaying the GUI (bartok.nvidia.com) and the computer whose X Display you are configuring (schoenberg.nvidia.com).
.PP
The simplest, most common, and least secure mechanism to do this is to use 'xhost' to allow access from the computer on which you are running
.B nvidia\-settings.
.nf

        (issued from bartok.nvidia.com)
        xhost +stravinsky.nvidia.com

        (issued from schoenberg.nvidia.com)
        xhost +stravinsky.nvidia.com

.fi
This will allow all X clients run on stravinsky.nvidia.com to connect and display on bartok.nvidia.com's X server and configure schoenberg.nvidia.com's X server.
.PP
Please see the
.BR xauth (1)
and
.BR xhost (1)
man pages, or refer to your system documentation on remote X applications and security.
You might also Google for terms such as "remote X security" or "remote X Windows", and see documents such as the Remote X Apps mini-HOWTO:
.sp
.ti +5
.__URL__ http://www.tldp.org/HOWTO/Remote-X-Apps.html
.sp
Please also note that the remote X server to be controlled must be using the NVIDIA X driver.
.SS 7. Licensing
The source code to
.B nvidia\-settings
is released as GPL.
The most recent official version of the source code is available here:
.sp
.ti +5
.__URL__ ftp://download.nvidia.com/XFree86/nvidia-settings/
.sp
Note that
.B nvidia\-settings
is simply an NV-CONTROL client.
It uses the NV-CONTROL X extension to communicate with the NVIDIA X server to query current settings and make changes to settings.
.PP
You can make additions directly to
.B nvidia\-settings,
or write your own NV-CONTROL client, using
.B nvidia\-settings
as an example.
.PP
Documentation on the NV-CONTROL extension and additional sample clients are available in the
.B nvidia\-settings
source tarball.
Patches can be submitted to linux-bugs@nvidia.com.
.SS 8. TODO
There are many things still to be added to
.B nvidia\-settings,
some of which include:
.TP
-
different toolkits?
The GUI for
.B nvidia\-settings
is cleanly abstracted from the backend of
.B nvidia\-settings
that parses the configuration file and commandline, communicates with the X server, etc.
If someone were so inclined, a different frontend GUI could be implemented.
.TP
-
write a design document explaining how
.B nvidia\-settings
is architected; presumably this would make it easier for people to become familiar with the code base.
.PP
If there are other things you would like to see added (or better yet, would like to add yourself), please contact linux-bugs@nvidia.com.
.SH FILES
.TP
.I ~/.nvidia\-settings\-rc
.SH EXAMPLES
.TP
.B nvidia\-settings
Starts the
.B nvidia\-settings
graphical interface.
.TP
.B nvidia\-settings \-\-load\-config\-only
Loads the settings stored in
.I ~/.nvidia\-settings\-rc
and exits.
.TP
.B nvidia\-settings \-\-rewrite\-config\-file
Writes the current X server configuration to 
.I ~/.nvidia\-settings\-rc
file and exits.
.TP
.B nvidia\-settings \-\-query FSAA
Query the value of the full-screen antialiasing setting.
.TP
.B nvidia\-settings \-\-assign RedGamma=2.0 \-\-assign BlueGamma=2.0 \-\-assign GreenGamma=2.0
Set the gamma of the screen to 2.0.
.SH AUTHOR
Aaron Plattner
.br
NVIDIA Corporation
.SH "SEE ALSO"
.BR nvidia\-xconfig (1)ifelse(__BUILD_OS__,Linux,[[[,
.BR nvidia\-installer (1)]]])
.SH COPYRIGHT
Copyright \(co 2006 NVIDIA Corporation.