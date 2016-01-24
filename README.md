Saurmon
=====

*aka* poor man's Ansible.

Initial purpose: To aggregate S.M.A.R.T values from all the disks in a Hadoop
cluster since disks were failing and I wanted to know why.

What it do: `runner` will copy a script to each host specified in a hosts config
file, using ssh-pass or public key auth, run that script, and then pipe the
results back to your local machine for analysing.
