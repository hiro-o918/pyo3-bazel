import sys
from pathlib import Path

import pytest

if __name__ == "__main__":
    p = Path(".").glob('**/*')
    files = [x for x in p if x.is_file()]
    print("\n".join([str(f) for f in files]))
    target = Path(__file__).parent
    sys.exit(pytest.main(["-s", "-v", target]))
