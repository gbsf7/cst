'# MWS Version: Version 2019.0 - Sep 20 2018 - ACIS 28.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2 fmax = 6
'# created = '[VERSION]2019.0|28.0.2|20180920[/VERSION]


'@ use template: Antenna - Planar_1.cfg

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "2", "6"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "2;4;6"
Dim sDefineAtName As String
sDefineAtName = "2;4;6"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------




'@ activate local coordinates

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.ActivateWCS "local"


'@ activate global coordinates

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.ActivateWCS "global"


'@ activate local coordinates

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.ActivateWCS "local"


'@ define material: FR-4 (lossy)

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3"
.Mu "1.0"
.Kappa "0.0"
.TanD "0.025"
.TanDFreq "10.0"
.TanDGiven "True"
.TanDModel "ConstTanD"
.KappaM "0.0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "0.0"
.ThermalType "Normal"
.ThermalConductivity "0.3"
.SetActiveMaterial "all"
.Colour "0.94", "0.82", "0.76"
.Wireframe "False"
.Transparency "0"
.Create
End With 


'@ new component: component1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Component.New "component1" 


'@ define brick: component1:substrate

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-28/2", "28/2" 
     .Yrange "0", "32" 
     .Zrange "-1", "0" 
     .Create
End With


'@ define brick: component1:solid1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-10", "10" 
     .Yrange "7.5", "28" 
     .Zrange "-1", "0" 
     .Create
End With


'@ activate global coordinates

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.ActivateWCS "global"


'@ activate local coordinates

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.ActivateWCS "local"


'@ define material: Copper (annealed)

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static"
.Type "Normal"
.SetMaterialUnit "Hz", "mm"
.Epsilon "1"
.Mu "1.0"
.Kappa "5.8e+007"
.TanD "0.0"
.TanDFreq "0.0"
.TanDGiven "False"
.TanDModel "ConstTanD"
.KappaM "0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstTanD"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "Nth Order"
.DispersiveFittingSchemeMu "Nth Order"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.FrqType "all"
.Type "Lossy metal"
.SetMaterialUnit "GHz", "mm"
.Mu "1.0"
.Kappa "5.8e+007"
.Rho "8930.0"
.ThermalType "Normal"
.ThermalConductivity "401.0"
.HeatCapacity "0.39"
.MetabolicRate "0"
.BloodFlow "0"
.VoxelConvection "0"
.MechanicsType "Isotropic"
.YoungsModulus "120"
.PoissonsRatio "0.33"
.ThermalExpansionRate "17"
.Colour "1", "1", "0"
.Wireframe "False"
.Reflection "False"
.Allowoutline "True"
.Transparentoutline "False"
.Transparency "0"
.Create
End With 


'@ define brick: component1:copper

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "copper" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-14", "-10" 
     .Yrange "28", "32" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:cop

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "cop" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-10", "14" 
     .Yrange "28", "32" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-14", "-10" 
     .Yrange "0", "28" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid3

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid3" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-10", "-2.5" 
     .Yrange "0", "7.5" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid4

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid4" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "2.5", "14" 
     .Yrange "0", "7.5" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid5

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid5" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "10", "14" 
     .Yrange "7.5", "28" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid6

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid6" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-2.5", "-1.5" 
     .Yrange "-0", "3" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid7

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid7" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "1.5", "2.5" 
     .Yrange "0", "3" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ activate global coordinates

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
WCS.ActivateWCS "global"


'@ define brick: component1:solid8

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid8" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-1", "1" 
     .Yrange "0", "12.5" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define sphere: component1:solid9

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Sphere 
     .Reset 
     .Name "solid9" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Axis "z" 
     .CenterRadius "3.6" 
     .TopRadius "0" 
     .BottomRadius "0" 
     .Center "0", "15", "0.1" 
     .Segments "0" 
     .Create 
End With


'@ delete shape: component1:solid9

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "component1:solid9" 


'@ define cylinder: component1:solid9

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid9" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .OuterRadius "3.6" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "0.1" 
     .Xcenter "0" 
     .Ycenter "15" 
     .Segments "0" 
     .Create 
End With 


'@ delete shape: component1:solid9

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "component1:solid9" 


'@ define cylinder: component1:round

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Cylinder 
     .Reset 
     .Name "round" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .OuterRadius "3.6" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "0.1" 
     .Xcenter "0" 
     .Ycenter "15" 
     .Segments "0" 
     .Create 
End With 


'@ define brick: component1:solid9

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid9" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-1", "1" 
     .Yrange "23", "28" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ delete shape: component1:solid9

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "component1:solid9" 


'@ define brick: component1:solid9

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid9" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-1", "1" 
     .Yrange "23", "28" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid10

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid10" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-10", "-8" 
     .Yrange "20", "21" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid11

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-9", "-8" 
     .Yrange "12.4", "20" 
     .Zrange "0", "0.1" 
     .Create
End With


'@ define brick: component1:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid12" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "8", "10" 
     .Yrange "20", "21" 
     .Zrange "0", "0.1" 
     .Create
End With



'@ define brick: component1:solid13

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid13" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "8", "9" 
     .Yrange "12.4", "20" 
     .Zrange "0", "0.1" 
     .Create
End With



'@ boolean add shapes: component1:cop, component1:copper

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:cop", "component1:copper" 


'@ boolean add shapes: component1:round, component1:solid10

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:round", "component1:solid10" 


'@ boolean add shapes: component1:solid11, component1:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid11", "component1:solid12" 


'@ boolean add shapes: component1:solid13, component1:solid2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid13", "component1:solid2" 


'@ boolean add shapes: component1:solid3, component1:solid4

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid3", "component1:solid4" 


'@ boolean add shapes: component1:solid5, component1:solid6

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid5", "component1:solid6" 


'@ boolean add shapes: component1:solid7, component1:solid8

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid7", "component1:solid8" 


'@ boolean add shapes: component1:solid7, component1:solid9

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid7", "component1:solid9" 


'@ boolean add shapes: component1:cop, component1:round

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:cop", "component1:round" 


'@ boolean add shapes: component1:solid11, component1:solid13

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid11", "component1:solid13" 


'@ boolean add shapes: component1:solid3, component1:solid5

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid3", "component1:solid5" 


'@ boolean add shapes: component1:solid3, component1:solid7

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:solid3", "component1:solid7" 


'@ boolean add shapes: component1:cop, component1:solid11

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:cop", "component1:solid11" 


'@ boolean add shapes: component1:cop, component1:solid3

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Add "component1:cop", "component1:solid3" 


'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:substrate", "2" 


'@ define brick: component1:solid2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-14", "14" 
     .Yrange "0", "32" 
     .Zrange "-1", "-1-0.1" 
     .Create
End With


'@ delete shape: component1:solid1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "component1:solid1" 


'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:cop", "9" 


'@ define port:1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "1*5.74", "1*5.74"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1", "1*5.74"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With



'@ define time domain solver parameters

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With


'@ set PBA version

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Discretizer.PBAVersion "2018092019"

'@ clear picks

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.ClearAllPicks 


'@ pick face

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Pick.PickFaceFromId "component1:cop", "56" 


