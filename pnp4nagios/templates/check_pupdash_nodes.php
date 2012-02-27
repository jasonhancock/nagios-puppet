<?php
/*
* Copyright (c) 2012 Jason Hancock <jsnbyh@gmail.com>
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is furnished
* to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
* This file is part of the nagios-puppet bundle that can be found
* at https://github.com/jasonhancock/nagios-puppet
*/

$alpha = 'CC';

$colors = array(
    '#888888' . $alpha,
    '#cc2211' . $alpha,
    '#ee7722' . $alpha,
    '#006699' . $alpha,
    '#009933' . $alpha,
    '#aaaaaa' . $alpha
);

$vlabel = 'Nodes';
    
$opt[1] = sprintf('-T 55 -l 0 --vertical-label "%s" --title "%s / %s"', $vlabel, $hostname, $servicedesc);
$def[1] = '';

$count = 0;

foreach ($DS as $i) {
    $def[1] .= rrd::def("var$i", $rrdfile, $DS[$i], 'AVERAGE');

    if ($i == '1') {
        $def[1] .= rrd::area ("var$i", $colors[$count], rrd::cut(ucfirst($NAME[$i]), 15));
    } else {
        $def[1] .= rrd::area ("var$i", $colors[$count], rrd::cut(ucfirst($NAME[$i]), 15), 'STACK');
    }

    $def[1] .= rrd::gprint  ("var$i", array('LAST','MAX','AVERAGE'), "%4.0lf %s\\t");

    $count++;
}

$def[1] .= 'COMMENT:"' . $TEMPLATE[$i] . '\r" ';
