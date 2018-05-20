#! /usr/bin/env python

from __future__ import print_function
import argparse
import os
import textwrap
import tempfile

FILE_PATH = os.path.dirname(__file__)


class Deploy(object):
    # (source, target)
    FILES_TO_LINK = [
        # Dot files
        ('~/dot_files/.bash_profile', '~/.bash_profile'),
        ('~/dot_files/.bashrc', '~/.bashrc'),
        ('~/dot_files/.inputrc', '~/.inputrc'),
        ('~/dot_files/.vim', '~/.vim'),
        ('~/dot_files/.vimrc', '~/.vimrc'),
        ('~/dot_files/.ideavimrc', '~/.ideavimrc'),
        ('~/dot_files/.ackrc', '~/.ackrc'),
        ('~/dot_files/.ctags', '~/.ctags'),
        ('~/dot_files/rcconda.sh', '~/rcconda.sh'),
        ('~/dot_files/gitignore_global', '~/.gitignore_global'),
        ('~/dot_files/flake8', '~/.config/flake8'),

        # Executables
        ('~/dot_files/git_diff_wrapper', '~/bin/git_diff_wrapper'),
        ('~/dot_files/git_branch_diff', '~/bin/git_branch_diff'),
        ('~/dot_files/circle_checker', '~/bin/circle_checker'),
        ('~/dot_files/serve_dir.py', '~/bin/serve_dir.py'),
        ('~/dot_files/imgcat', '~/bin/imgcat'),
        ('~/dot_files/make_tags', '~/bin/make_tags'),
        ('~/dot_files/clean_vim_backup.py', '~/bin/clean_vim_backup.py'),
        ('~/dot_files/diffconflicts', '~/bin/diffconflicts'),
        ('~/dot_files/myip', '~/bin/myip'),

    ]

    PATHS_TO_CREATE = [
        '~/bin',
        '~/.undodir',
        '~/.config',
    ]

    def __init__(self, kind, dry_run=False):
        self.kind = kind
        self.dry_run = dry_run

    def run(self):
        self.create_paths()
        self.make_file_links()
        self.make_git_config()
        self.ensure_bash_history()

    def build_base_env(self):
        raise NotImplementedError('need to write this')

    def install_miniconda(self):
        command_list = []
        tmp_dir = '/tmp'
        if os.environ['OS_TYPE'] == 'mac':
            script_name = 'Miniconda3-latest-MacOSX-x86_64.sh'
        elif os.environ['OS_TYPE'] == 'linux':
            script_name = 'Miniconda3-latest-Linux-x86_64.sh'
        else:
            raise ValueError('Unrecognized OS')

        url = os.path.join(
            'http://repo.continuum.io/miniconda',
            script_name,
        )
        downloaded_file = os.path.join(tmp_dir, 'miniconda.sh')

        cmd = 'wget {} -O {}'.format(url, downloaded_file)
        command_list.append(cmd)

        cmd = 'bash {} -b -p "$HOME/miniconda"'.format(downloaded_file)
        command_list.append(cmd)

        cmd = 'rm {}'.format(downloaded_file)
        command_list.append(cmd)

        for cmd in command_list:
            print(cmd)
            if not self.dry_run:
                os.system(cmd)

    def build_conda_env(self):
        rc_file = os.path.expanduser('~/rcconda.sh')
        env_file = os.path.expanduser('~/dot_files/environment.yml')

        command_list = []
        cmd = '. {} && conda env create --force -f {}'.format(
            rc_file,
            env_file
        )
        command_list.append(cmd)

        cmd = 'mkdir -p "$HOME/bash_hooks"'
        command_list.append(cmd)

        cmd = 'ln -sf ~/dot_files/viz_init.sh  "$HOME/bash_hooks"'
        command_list.append(cmd)

        cmd = 'jupyter labextension install @pyviz/jupyterlab_holoviews'
        command_list.append(cmd)

        for cmd in command_list:
            print(cmd)
            if not self.dry_run:
                os.system(cmd)

    def create_paths(self):
        for path in self.PATHS_TO_CREATE:
            path = os.path.expanduser(path)
            if not os.path.isdir(path):
                if self.dry_run:
                    print('mkdir -p {}'.format(path))
                else:
                    os.makedirs(path)

    def make_file_links(self):
        for (source_name, target_name) in self.FILES_TO_LINK:
            src = os.path.expanduser(source_name)
            tgt = os.path.expanduser(target_name)
            cmd = 'ln -sf {src} {tgt}'.format(src=src, tgt=tgt)

            print(cmd)
            if not self.dry_run:
                os.system(cmd)

    def ensure_bash_history(self):
        history_file = os.path.expanduser('~/.bash_history')
        if not os.path.isfile(history_file):
            cmd = 'cp ~/dot_files/fake_bash_history {}'.format(history_file)
            print(cmd)
            if not self.dry_run:
                os.system(cmd)

    def make_git_config(self):
        if self.kind == 'personal':
            context = dict(
                name='Rob deCarvalho',
                email='robdmc@gmail.com',
                github_user_spec=textwrap.dedent(
                    """
                    [github]
                        user = robdmc
                    """
                )
            )
        elif self.kind == 'generic':
            context = dict(
                name='Generic User',
                email='generic@user.net',
                github_user_spec='',
            )

        else:
            raise ValueError('"kind" must be in ["personal", "generic"]')

        with open(os.path.join(FILE_PATH, 'gitconfig_template')) as f:
            template = f.read()
            contents = template.format(**context)

        if self.dry_run:
            print('=' * 40 + ' .git_config ' + '=' * 40)
            print(contents)
            print('=' * 40 + ' end .git_config ' + '=' * 40)
        else:
            with open(os.path.expanduser('~/.gitconfig'), 'w') as out:
                out.write(contents)


if __name__ == '__main__':

    msg = textwrap.dedent("""Deploy dotfiles""")
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=msg)

    parser.add_argument(
        '-d', '--dry-run', dest='dry_run', action='store_true', default=False,
        help='Use with any other flag to not do anythin, just print commands')

    parser.add_argument(
        '-g', '--generic', dest='generic', action='store_true', default=False,
        help='Use generic gitconfig when deploying dotfiles')

    parser.add_argument(
        '-v', '--venv', dest='venv', action='store_true', default=False,
        help='Don\'t deploy.  Just install default virtualenv at ~/envs/base')

    parser.add_argument(
        '-c', '--conda', dest='conda', action='store_true', default=False,
        help='Don\'t deploy.  Just create the "viz" conda environment')

    parser.add_argument(
        '--miniconda', dest='miniconda', action='store_true', default=False,
        help='Download and install miniconda')

    args = parser.parse_args()

    # Determine what type of deployment was requested
    if args.generic:
        deploy = Deploy('generic', args.dry_run)
    else:
        deploy = Deploy('personal', args.dry_run)

    # Only build the conda env
    if args.conda:
        deploy.build_conda_env()

    # Only install Miniconda
    elif args.miniconda:
        deploy.install_miniconda()

    # Only build the base env
    elif args.venv:
        deploy.build_base_env()

    # Do a general deployment
    else:
        deploy.run()




#deploy = Deploy('personal')
#deploy.run()
