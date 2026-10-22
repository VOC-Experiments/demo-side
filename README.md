# Delayed cascade arm and operator recovery fixture

The v1.3.0 tag was deliberately moved to this corrected test fixture. Direct builds are normal on all five rows. Only the first in-cascade OpenWrt24.10 x86_64 source attempt pauses1200seconds and then fails; an operator source rerun bypasses both pause and failure. This tests D03/D04 before D06 recovery. Old captures keep their original hooks and evidence; the earlier direct-failure fixture is not counted as the cascade-failure proof. No coordinator timer, flag or state is added.
