#! /bin/sh

for ((i = 1; i <= 6; i++)); do

	printf "%s" \
	"
\begin{figure}[H]
	\centering
	\includegraphics[width=4.5in]{p$i.eps}
	\caption{Problem $i}
	\label{fig:$i}
\end{figure}

\begin{framed}
	\lstinputlisting{p$i.spice}
\end{framed}

"


done
