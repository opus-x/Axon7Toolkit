@echo off
color 1f
echo *************************************************
echo *                 Axon7Tool v1.0
echo *                 by benkores
echo *                 for ZTE A2017U
echo *************************************************
IF NOT EXIST BUILD.TXT. (GOTO SETBUILD) ELSE (GOTO OPTIONS)
:SETBUILD
echo(
set /p build=Which build are you on? (B18/B20/B20_boot/B27/B29/B15_N/Custom)
if {%build%}=={B18} (echo B18 >>build) & (echo B18 >>B18) & (GOTO Options)
if {%build%}=={B20} (echo B20 >>build) & (echo B20 >>B20) & (GOTO Options)
if {%build%}=={B20_boot} (echo B20_boot >>build) & (echo B20_boot >>B20_boot) & (GOTO Options)
if {%build%}=={B27} (echo B27 >>build) & (echo B27 >>B27) & (GOTO Options)
if {%build%}=={B29} (echo B29 >>build) & (echo B29 >>B29) & (GOTO Options)
if {%build%}=={B15_N} (echo B15_N >>build) & (echo B15_N >>B15_N) & (GOTO Options)
if {%build%}=={Custom} (echo Custom >>build) & (echo Custom >>Custom) & (GOTO Options)
