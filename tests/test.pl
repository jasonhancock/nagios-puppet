#!/usr/bin/perl

use strict;
use warnings;
use Test::Simple tests => 18;

my $fixtures = {
    'changed.yaml' => {
        'time'     => 1363811850,
        'exitcode' => 0,
    },
    'failed.yaml'  => {
        'time'     => 1363803993,
        'exitcode' => 2,
    },
    'success.yaml' => {
        'time'     => 1363804916,
        'exitcode' => 0,
    },
    'unchanged.yaml' => {
        'time'     => 1363815690,
        'exitcode' => 0,
    },
};

my $output=`../plugins/check_puppet_lastrun`;
ok($output=~m/UNKNOWN -  you didn't supply a threshold argument/, "no thresholds test");
ok(($? >> 8) == 3, "no thresholds exit code test");

# Bogus file
my $warning  = time();
my $critical = time();
$output=`../plugins/check_puppet_lastrun -w $warning -c $critical -f fixtures/bogus.yaml`;
ok($output=~m/UNKNOWN - File doesn't exist or not readable/, "bogus file test");
ok(($? >> 8) == 3, "bogus file exit code test");

$warning  = time() - $fixtures->{'success.yaml'}{'time'} + 10;
$critical = time() - $fixtures->{'success.yaml'}{'time'} + 20;
$output=`../plugins/check_puppet_lastrun -w $warning -c $critical -f fixtures/success.yaml`;
ok($output=~m/OK - Last puppet run \d+ seconds ago/, "varying thresholds ok test");
ok(($? >> 8) == 0, "varying thresholds ok exit code test");

$warning  = time() - $fixtures->{'success.yaml'}{'time'} - 10;
$critical = time() - $fixtures->{'success.yaml'}{'time'} + 10;
$output=`../plugins/check_puppet_lastrun -w $warning -c $critical -f fixtures/success.yaml`;
ok( $output=~m/WARNING - Last puppet run \d+ seconds ago/, "varying thresholds warning test");
ok(($? >> 8) == 1, "varying thresholds warning exit code test");

$warning  = time() - $fixtures->{'success.yaml'}{'time'} - 10;
$critical = time() - $fixtures->{'success.yaml'}{'time'} - 5;
$output=`../plugins/check_puppet_lastrun -w $warning -c $critical -f fixtures/success.yaml`;
ok( $output=~m/CRITICAL - Last puppet run \d+ seconds ago/, "varying thresholds critical test");
ok(($? >> 8) == 2, "varying thresholds critical exit code test");

foreach my $fixture(sort keys %{$fixtures}) {
    $warning  = time() - $fixtures->{'success.yaml'}{'time'} + 10;
    $critical = time() - $fixtures->{'success.yaml'}{'time'} + 20;

    my $output=`../plugins/check_puppet_lastrun -w $warning -c $critical -f fixtures/$fixture`;
    ok($output=~m/Last puppet run \d+ seconds ago/, "$fixture output test");
    ok(($? >> 8) == $fixtures->{$fixture}{'exitcode'}, "$fixture exit code test");
}
