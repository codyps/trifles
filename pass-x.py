import subprocess
def get_output(cmd):
      # Bunch of boilerplate to catch the output of a command:
      pipe = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
      (output, errout) = pipe.communicate()
      assert pipe.returncode == 0 and not errout
      return output

def get_pass_x(ident):
      cmd = "pass-x -p %s" % ident
      return get_output(cmd).strip().lstrip('"').rstrip('"')
