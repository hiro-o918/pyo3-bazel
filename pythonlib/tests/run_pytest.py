import sys
from pathlib import Path

import pytest

if __name__ == "__main__":
    target = Path(__file__).parent
    sys.exit(pytest.main(["-s", "-v", str(target)]))
