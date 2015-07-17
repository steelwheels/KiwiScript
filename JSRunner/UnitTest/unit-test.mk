#
#
#

JSRUNNER	= $(HOME)/Tools/bin/jsrunner
TEST_DIR	= ../UnitTest
OUT_DIR		= $(BUILD_DIR)/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)

UNIT_TEST_LOG		= $(OUT_DIR)/unit-test.log
UNIT_TEST_OK_LOG	= $(TEST_DIR)/unit-test.log.OK

all: check logfile programs compare

check: dummy
	test -x $(JSRUNNER)

logfile: dummy
	rm -f $(UNIT_TEST_LOG)
	touch $(UNIT_TEST_LOG)

compare: dummy
	diff $(UNIT_TEST_LOG) $(UNIT_TEST_OK_LOG)

programs: p0 p1

p0: $(TEST_DIR)/Sample/sample-0.js
	echo "***** sample-0.js" | tee -a $(UNIT_TEST_LOG)
	$(JSRUNNER) $<  | tee -a $(UNIT_TEST_LOG)

p1: $(TEST_DIR)/Sample/console-0.js
	echo "***** console-0.js" | tee -a $(UNIT_TEST_LOG)
	$(JSRUNNER) $<  | tee -a $(UNIT_TEST_LOG)

dummy:
