
```bash

vi my-bash-script.md
i

#!/bin/bash

echo $(date) >> my-bash-script-file.txt
ESC
wq

./my-bash-script.sh
-bash: ./my-bash-script.sh: Permission denied

ls -alh
chmod 700 my-bash-script.sh
ls -alh



```
