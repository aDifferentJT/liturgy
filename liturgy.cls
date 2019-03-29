\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{liturgy}[2019/03/25 Liturgy LaTeX class]

\DeclareOption{longa4booklet}{\PassOptionsToPackage{a4paper}{geometry}\PassOptionsToPackage{paperwidth=0.5\paperwidth}{geometry}}
%\DeclareOption{booklet}{\PassOptionsToPackage{print}{booklet}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}
\RequirePackage[margin=0.2in,heightrounded]{geometry}
\RequirePackage[heightrounded]{geometry}
%RequirePackage[print]{booklet}
\RequirePackage{amssymb}
\RequirePackage{environ}
\RequirePackage{listofitems}
\RequirePackage{xstring}
\RequirePackage{etoolbox}
\RequirePackage[british]{babel}
\RequirePackage[autostyle=false, english=american]{csquotes}
\RequirePackage{longtable}
\RequirePackage{tabu}
\RequirePackage[nomessages]{fp}

\flushbottom

\MakeOuterQuote{"} %"
  %}

  \tolerance=500
  \hyphenpenalty=10000

  \newcommand{\vgap}{\vspace{0.5\baselineskip}}

  \newenvironment{leader}{
    \par\ignorespaces
  }{
  }

\newenvironment{all}{
  \bfseries
    \par\ignorespaces
}{
}
\newcommand{\inlineall}[1]{\textbf{#1}}

\newcommand{\instruction}[1]{{
\vgap
  \small
    \itshape
    \centering
#1
    \par
    \nopagebreak
}}

\begingroup
\catcode`&=\active
\gdef\redefineampersand{\def&{\myampersand}}
\endgroup

\begingroup
\catcode`<=\active
\catcode`>=\active
\catcode`|=\active
\gdef\redefineangles{\def<{\myleftangle}\def>{\myrightangle}\def|{\myverticalbar}}
\endgroup

\newenvironment{canticle}{
  \setlength{\parskip}{0.5\baselineskip}
  \setlength{\leftskip}{\parindent}
  \setlength{\parindent}{-\parindent}
  \catcode`&=\active
    \newcommand{\myampersand}{
      $\blacklozenge$
        \par \nopagebreak \vspace{-\parskip}
    }
  \redefineampersand
    \widowpenalties 1 10000
    \newbox\emptybox
    \setbox\emptybox=\vbox{\par~}
  \par
}{
  \par
  \vgap
}

\newcommand{\parseresponsesbody}[1]{
  \expandafter\setsepchar\endlinechar
    \setsepchar{~}
  \readlist*\mylines{#1}
  \foreachitem\x\in\mylines{
    \StrChar{\x}{1}[\firstchar]
      \IfBeginWith{\x}{<}{
        \par\StrGobbleLeft{\x}{1}
      }{
        \IfBeginWith{\x}{>}{
          \par{\bfseries\StrGobbleLeft{\x}{1}}
        }{
          \IfBeginWith{\x}{|}{
            \par{\small\StrGobbleLeft{\x}{1}}
          }{
            \IfBeginWith{\x}{-}{
              \vgap
            }{
              \IfBeginWith{\x}{%}{
              }{
Error: Invalid line start of \x
         \PackageWarning{liturgy}{Invalid line start in responses}{In responses all lines must begin with one of <,>,|,-}
              }
            }
          }
        }
      }
  }
}
\newenvironment{responses}{
  \setlength\parskip{0pt}
  \setlength{\leftskip}{\parindent}
  \setlength{\parindent}{-\parindent}
  \endlinechar=`~
    \Collect@Body\parseresponsesbody
}{
  \par
  \vspace{-\baselineskip}
  \vgap
}

\newcommand{\listgetsafe}[4]{
  \FPifgt{#1}{#3}
#4
  \else
#2[#1]
    \fi
}

\newcommand{\sidebyside}[3]{
  \setsepchar{\\}
  \ignoreemptyitems
    \readlist*\leftlines{#1}
  \readlist*\centerlines{#2}
  \readlist*\rightlines{#3}
  \FPmax\n{\leftlineslen}{\centerlineslen}
  \FPmax\n{\n}{\rightlineslen}
  \FPeval\n{clip(n + 1)}
  \FPset\i{1}

  %   \def\lines{}
  \newtoks\lines
    \newcommand{\addtolines}[1]{\lines=\expandafter{\the\lines##1}}
  \loop
    \FPiflt{\i}{\n}
  \expandafter\addtolines\expandafter{\expandafter\listgetsafe\expandafter{\i}{\leftlines}{\leftlineslen}{} &}
  \expandafter\addtolines\expandafter{\expandafter\listgetsafe\expandafter{\i}{\centerlines}{\centerlineslen}{} &}
  \expandafter\addtolines\expandafter{\expandafter\listgetsafe\expandafter{\i}{\rightlines}{\rightlineslen}{} \\}
  \FPeval\i{clip(i + 1)}
  \repeat

    \setlength{\LTpre}{0pt}
  \setlength{\LTpost}{0pt}
  \begin{longtabu}{XcX}
  \the\lines
    \end{longtabu}
}

