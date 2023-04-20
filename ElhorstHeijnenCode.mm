<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Standard spatial probit" FOLDED="false" ID="ID_549521883" CREATED="1615520193169" MODIFIED="1615800569606" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle" zoom="1.211">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" fit_to_viewport="false"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#000000" STYLE="fork">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10.0 pt" SHAPE_VERTICAL_MARGIN="10.0 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="2" RULE="ON_BRANCH_CREATION"/>
<node TEXT="run_regressions" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_477765385" CREATED="1615525615618" MODIFIED="1615525695410" HGAP_QUANTITY="98.99999704957015 pt" VSHIFT_QUANTITY="-344.24998974055086 pt">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_1246684670" STARTINCLINATION="-71;98;" ENDINCLINATION="-31;-1;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<hook NAME="FreeNode"/>
</node>
<node TEXT="spatial_probit_Vogler" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_1246684670" CREATED="1615525640598" MODIFIED="1615525666497" HGAP_QUANTITY="221.24999340623634 pt" VSHIFT_QUANTITY="-326.99999025464086 pt">
<hook NAME="FreeNode"/>
</node>
<node TEXT="tnprob" LOCALIZED_STYLE_REF="defaultstyle.floating" FOLDED="true" POSITION="right" ID="ID_1595467229" CREATED="1615520426693" MODIFIED="1615521444395" HGAP_QUANTITY="344.9999897181991 pt" VSHIFT_QUANTITY="-250.49999253451844 pt">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_1108733819" STARTINCLINATION="-12;13;" ENDINCLINATION="5;-24;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<hook NAME="FreeNode"/>
<node TEXT="calculate the probability for a variable that  (y&gt;0) that follows multivariate Normal" ID="ID_846677242" CREATED="1615520505258" MODIFIED="1615520878813"/>
<node TEXT="Let y be multivariate normal with mean mu and variance Sigma." ID="ID_1059738935" CREATED="1615520880176" MODIFIED="1615520882697"/>
<node TEXT="Then the program calculates the probability that (y&gt;0)==s using GHK" ID="ID_1238819232" CREATED="1615520897520" MODIFIED="1615521213799"/>
<node TEXT="¿Perhaps the probability that for y´s that are greater than zero, the probability that they are equal to s?" ID="ID_1848594469" CREATED="1615520998128" MODIFIED="1615521031603"/>
</node>
<node TEXT="loglik" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_1387259866" CREATED="1615520205077" MODIFIED="1615521385089" HGAP_QUANTITY="191.249994300306 pt" VSHIFT_QUANTITY="-215.9999935626986 pt">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_1595467229" STARTINCLINATION="42;6;" ENDINCLINATION="-68;-37;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<hook NAME="FreeNode"/>
<node TEXT="tnprob" ID="ID_1956423885" CREATED="1615520304646" MODIFIED="1615521464575">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_463117993" STARTINCLINATION="19;12;" ENDINCLINATION="20;-40;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<hook NAME="accessories/plugins/HierarchicalIcons.properties"/>
</node>
</node>
<node TEXT="p" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_1108733819" CREATED="1615521207871" MODIFIED="1615521449535" HGAP_QUANTITY="360.7499892488125 pt" VSHIFT_QUANTITY="-193.4999942332508 pt">
<hook NAME="FreeNode"/>
</node>
<node TEXT="lndetmc" LOCALIZED_STYLE_REF="defaultstyle.floating" FOLDED="true" POSITION="right" ID="ID_1760382180" CREATED="1615524833551" MODIFIED="1615778456924" HGAP_QUANTITY="101.24999698251494 pt" VSHIFT_QUANTITY="-131.2499960884453 pt">
<hook NAME="FreeNode"/>
<node TEXT="computes Barry and Pace MC approximation to log det(I-rho*W)" ID="ID_639857577" CREATED="1615524854951" MODIFIED="1615524855498"/>
</node>
<node TEXT="f_sar" LOCALIZED_STYLE_REF="defaultstyle.floating" FOLDED="true" POSITION="right" ID="ID_613753823" CREATED="1615521997621" MODIFIED="1615522048411" HGAP_QUANTITY="21.749999351799516 pt" VSHIFT_QUANTITY="-95.99999713897714 pt">
<hook NAME="FreeNode"/>
<node TEXT="evaluates concentrated log-likelihood for the spatial autoregressive model using sparse matrix algorithms" ID="ID_948367841" CREATED="1615522008463" MODIFIED="1615522022109"/>
<node TEXT="RETURNS:a  scalar equal to minus the log-likelihood function value at the parameter rho" ID="ID_397743723" CREATED="1615522027831" MODIFIED="1615522048411"/>
</node>
<node TEXT="z" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_463117993" CREATED="1615520326676" MODIFIED="1615521456027" HGAP_QUANTITY="224.99999329447763 pt" VSHIFT_QUANTITY="-79.49999763071544 pt">
<hook NAME="FreeNode"/>
<hook NAME="accessories/plugins/HierarchicalIcons.properties"/>
</node>
<node TEXT="matadd" LOCALIZED_STYLE_REF="defaultstyle.floating" FOLDED="true" POSITION="right" ID="ID_707216950" CREATED="1615524986631" MODIFIED="1615524995735" HGAP_QUANTITY="-0.7499999776482582 pt" VSHIFT_QUANTITY="-56.249998323619415 pt">
<hook NAME="FreeNode"/>
<node TEXT="result = matadd(x,y)" ID="ID_75626512" CREATED="1615524996851" MODIFIED="1615525004207"/>
<node TEXT="performs matrix addition even if matrices are not of the same dimension, but are row or column compatible" ID="ID_1848595457" CREATED="1615525010473" MODIFIED="1615525021451"/>
</node>
<node TEXT="hessian" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_514209421" CREATED="1615522168182" MODIFIED="1615778459427" HGAP_QUANTITY="339.74998987466125 pt" VSHIFT_QUANTITY="-47.24999859184031 pt">
<hook NAME="FreeNode"/>
<node TEXT="hessian(f,x,varargin)" ID="ID_1227735476" CREATED="1615522240674" MODIFIED="1615522251187"/>
<node TEXT="Computes finite difference Hessian" ID="ID_575301691" CREATED="1615522172745" MODIFIED="1615522181130"/>
<node TEXT="fval = func(x,varargin)" ID="ID_464969505" CREATED="1615522259913" MODIFIED="1615522263322"/>
</node>
<node TEXT="pinv" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_148447483" CREATED="1615522494014" MODIFIED="1615522503597" HGAP_QUANTITY="374.24998884648113 pt" VSHIFT_QUANTITY="53.99999839067464 pt">
<hook NAME="FreeNode"/>
</node>
<node TEXT="invpd" LOCALIZED_STYLE_REF="defaultstyle.floating" FOLDED="true" POSITION="right" ID="ID_1278215403" CREATED="1615522414326" MODIFIED="1615522539521" HGAP_QUANTITY="245.24999269098066 pt" VSHIFT_QUANTITY="61.49999816715723 pt">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_148447483" STARTINCLINATION="17;-75;" ENDINCLINATION="-27;-14;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<hook NAME="FreeNode"/>
<node TEXT="xinv = invpd(x)" ID="ID_551005201" CREATED="1615522464403" MODIFIED="1615522465613"/>
<node TEXT="generalized inverse of non PD matrix (Moore-Penrose)" ID="ID_587962505" CREATED="1615522453124" MODIFIED="1615522474244"/>
<node TEXT="RETURNS: xinv = Moore-Penrose psuedo matrix inverse" ID="ID_1781139250" CREATED="1615522484180" MODIFIED="1615522485260"/>
</node>
<node TEXT="run_regressions" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_475369025" CREATED="1615784732831" MODIFIED="1615784740396" HGAP_QUANTITY="18.749999441206484 pt" VSHIFT_QUANTITY="97.49999709427365 pt">
<hook NAME="FreeNode"/>
<node TEXT="load the data" ID="ID_170820219" CREATED="1615784746901" MODIFIED="1615784749918"/>
</node>
<node TEXT="sar (y, x, W, info)" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_1465800537" CREATED="1615778541608" MODIFIED="1615784743951" HGAP_QUANTITY="140.99999579787269 pt" VSHIFT_QUANTITY="259.49999226629757 pt">
<hook NAME="FreeNode"/>
<node TEXT="PURPOSE: computes spatial autoregressive model estimates y = p*W*y + X*b + e, using sparse matrix algorithms" ID="ID_1571255395" CREATED="1615778721528" MODIFIED="1615778727680"/>
<node TEXT="y = dependent variable vector" ID="ID_1719505227" CREATED="1615778736806" MODIFIED="1615778745235"/>
<node TEXT="x = explanatory variables matrix, (with intercept term in first     column if used)" ID="ID_1967682467" CREATED="1615778746715" MODIFIED="1615778766852"/>
<node TEXT="W = standardized weight matrix" ID="ID_120151010" CREATED="1615778768003" MODIFIED="1615778772966"/>
</node>
<node TEXT="f_sar(rho,detval,epe0,eped,epe0d,n)" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_1234586269" CREATED="1615800504343" MODIFIED="1615800566796" HGAP_QUANTITY="157.4999953061344 pt" VSHIFT_QUANTITY="355.4999894052747 pt">
<hook NAME="FreeNode"/>
<node TEXT="evaluates concentrated log-likelihood for the spatial autoregressive model using sparse matrix algorithms" ID="ID_1481791960" CREATED="1615800541480" MODIFIED="1615800545624"/>
</node>
<node TEXT="sar_lndet()" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_1878955570" CREATED="1615799448122" MODIFIED="1615800569606" HGAP_QUANTITY="380.24998866766725 pt" VSHIFT_QUANTITY="398.9999881088737 pt">
<hook NAME="FreeNode"/>
</node>
<node TEXT="f2_sar(parm,y,X,W,ldet)" LOCALIZED_STYLE_REF="defaultstyle.floating" POSITION="right" ID="ID_1529508068" CREATED="1615799783307" MODIFIED="1615800530570" HGAP_QUANTITY="178.49999468028557 pt" VSHIFT_QUANTITY="464.9999861419205 pt">
<hook NAME="FreeNode"/>
<node TEXT="Likelihood like" ID="ID_503255891" CREATED="1615799810329" MODIFIED="1615799818625"/>
<node TEXT="evaluates log-likelihood -- given ML estimates spatial autoregressive model using sparse matrix algorithms" ID="ID_181324118" CREATED="1615799819401" MODIFIED="1615799832891"/>
<node TEXT="f2_sar(parm,y,X,W,ldet)" ID="ID_806506177" CREATED="1615800408674" MODIFIED="1615800408674"/>
</node>
<node TEXT="sar.m" POSITION="left" ID="ID_686578852" CREATED="1615778486815" MODIFIED="1615778489856">
<edge COLOR="#0000ff"/>
</node>
</node>
</map>
