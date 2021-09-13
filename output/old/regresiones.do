
#BASELINE
reg mktShrChgPc i.crisis#c.capRatioPc   mktShrAss prov casasAss08  ALIQs1_1ratioWPc  prevRatioPPc IRLoansARSWRealMA6 depRatioAssPc depRatioWPc  i.t i.bGroup, cluster(ID_entidad )

reg mktShareChgPctg capital AssetsL 

reg mktShrChgPc i.crisis   mktShrAss prov casasAss08  ALIQs1_1ratioWPc  prevRatioPPc IRLoansARSWRealMA6 depRatioAssPc depRatioWPc  i.t i.bGroup, cluster(ID_entidad )
predict pMktShrChgPc, xb

Less than 25
reg mktShrChgPc i.crisis#c.capRatioPc   mktShrAss prov casasAss08  ALIQs1_1ratioWPc  prevRatioPPc IRLoansARSWRealMA6 depRatioAssPc depRatioWPc  i.t i.ID_entidad if capRatioPc<25, cluster(ID_entidad )

Less than 50
reg mktShrChgPc i.crisis#c.capRatioPc  mktShrAss prov casasAss08  ALIQs1_1ratioWPc  prevRatioPPc IRLoansARSWRealMA6 depRatioAssPc depRatioWPc  i.ID_entidad i.crisis if capRatioPc<50, cluster(ID_entidad)

Less than 70
reg mktShrChgPc c.capRatioPc c.capRatioPc#c.capRatioPc  mktShrAss prov casasAss08  ALIQs1_1ratioWPc  prevRatioPPc IRLoansARSWRealMA6 depRatioAssPc depRatioWPc  i.crisis if capRatioPc<70

(some of these banks are investment banks but they do have some depositrs ratio to activo greather than 20%)

twoway (scatter residuals capRatioPc if capRatioPc<50, sort)

reg mktShrChgPc i.crisis#c.capRatioPc   mktShrAss prov casasAss08  ALIQs1_1ratioWPc  prevRatioPPc IRLoansARSWRealMA6 depRatioAssPc depRatioWPc  i.t i.bGroup, cluster(ID_entidad )

C8
C8Est
C8Est_w
reg D1.mktShareAct L1.C8 L2.C8 L3.C8 L4.C8 L5.C8 L6.C8 L7.C8 L8.C8 L1.mktShareAct casNpcia L1.ALIQs1_1ratio L2.ALIQs1_1ratio L3.ALIQs1_1ratio L1.AprevActPRratioW L1.RtasaIntPRARS L1.PdepVistaDEP i.crisisTodas i.IDent

