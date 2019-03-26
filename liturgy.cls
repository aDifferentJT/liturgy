\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{liturgy}[2019/03/25 Liturgy LaTeX class]

\LoadClass[a5paper]{article}
\RequirePackage[margin=0.5in,heightrounded]{geometry}
\RequirePackage{amssymb}
\RequirePackage{environ}
\RequirePackage{listofitems}
\RequirePackage{xstring}
\RequirePackage{etoolbox}
\RequirePackage[british]{babel}
\RequirePackage[autostyle=false, english=american]{csquotes}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\flushbottom

\MakeOuterQuote{"} %"

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
}

