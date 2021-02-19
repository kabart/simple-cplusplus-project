CC = g++
INCLUDEDIR = include
SOURCEDIR = src
BUILDDIR = build

TARGET = $(BUILDDIR)/run

DEPFLAGS = -Iinclude -MMD -MP
CFLAGS = -pthread -std=c++17 -Wall
LDFLAGS = -Llib

SOURCES = $(wildcard src/*.cpp)
OBJECTS = $(SOURCES:$(SOURCEDIR)/%.cpp=$(BUILDDIR)/%.o)
DEPENDS = ${OBJECTS:.o=.d}

all: target test

target: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(BUILDDIR)/%.o: $(SOURCEDIR)/%.cpp | $(BUILDDIR)
	$(CC) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

-include $(DEPENDS)

$(BUILDDIR):
	mkdir -p $@

clean:
	$(RM) $(TARGET) $(OBJECTS) $(DEPENDS)

TESTDIR = test
GTESTDIR = /usr/src/gtest/lib
BUILDTEST = build-test

TESTSRC = $(wildcard $(TESTDIR)/*.cpp)
TESTOBJ = $(TESTSRC:$(TESTDIR)/%.cpp=$(BUILDTEST)/%.o)

TEST = $(BUILDTEST)/runTests

GTESTFLAGS = -g -L$(GTESTDIR) -lgtest -lgtest_main -lpthread

test: $(TEST)

$(TEST): $(TESTOBJ)
	$(CC) $(CFLAGS) $(TESTSRC) $(GTESTDIR)/libgtest.a -o $(TEST)

$(BUILDTEST)/%.o: $(TESTDIR)/%.cpp | $(BUILDTEST)
	$(CC) $(CFLAGS) $(GTESTFLAGS) -c $^ -o $@

$(BUILDTEST):
	mkdir -p $@

cleanAll: clean cleanTest

cleanTest:
	$(RM) $(TEST) $(TESTOBJ)
