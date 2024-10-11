# 设置JAVA_HOME路径, 可以修改为指定的Java版本
# JAVA_HOME=/root/.sdkman/candidates/java/11.0.24-amzn

# C++编译器和编译选项
CXX=g++
CXXFLAGS=-shared -fPIC -O2 -std=c++11 -I${JAVA_HOME}/include -I${JAVA_HOME}/include/linux
LDFLAGS=-lrt -lpthread

# 变量
JVM_LOCALS=JvmLocals
JVM_LOCALS_AGENT=JvmLocalsAgent
JAVA_DIR_PATH=github/elroy93/jvmlocals

# 源码文件列表
SRC_AGENT_CPP=${JVM_LOCALS_AGENT}.cpp
SRC_TARGET_FILE_JVM_LOCALS_JNI_HEADER_JAVA=${JAVA_DIR_PATH}/${JVM_LOCALS}.java

# 生成的文件 
TARGET_FILE_AGENT_SO=lib${JVM_LOCALS_AGENT}.so
TARGET_FILE_JVM_LOCALS_JNI_HEADER=github_elroy93_jvmlocals_${JVM_LOCALS}.h

# java的编译阐述
JAVAC=javac
JAVA=java
JAVACFLAGS= -g:lines,vars,source -encoding UTF-8
JAVAFLAGS=-agentpath:./${TARGET_FILE_AGENT_SO} -Djava.library.path=./ -XX:+ShowMessageBoxOnError -Xint -XX:-UseCompressedOops -XX:-TieredCompilation

##################################################################################

# 默认目标，编译C++库
all: $(TARGET_FILE_AGENT_SO)
	@echo "=== 编译完成 ==="

# 编译C++共享库
$(TARGET_FILE_AGENT_SO): $(SRC_AGENT_CPP) $(TARGET_FILE_JVM_LOCALS_JNI_HEADER)
	$(CXX) $(CXXFLAGS) $(SRC_AGENT_CPP) -o $(TARGET_FILE_AGENT_SO) $(LDFLAGS)
	@echo "=== Agent C++ 编译完成 ==="

$(TARGET_FILE_JVM_LOCALS_JNI_HEADER): $(SRC_TARGET_FILE_JVM_LOCALS_JNI_HEADER_JAVA)
	${JAVAC} -h . $(SRC_TARGET_FILE_JVM_LOCALS_JNI_HEADER_JAVA)
	rm -rf $(JVM_LOCALS).class
	@echo "=== JNI 头文件生成完成 ==="

##################################################################################

test: $(TARGET_FILE_AGENT_SO) 
	@echo "=== 测试jni程序开始运行 ==="
	$(JAVAC) $(JAVACFLAGS) ./$(JAVA_DIR_PATH)/$(JVM_LOCALS).java
	$(JAVA) $(JAVAFLAGS) $(JAVA_DIR_PATH)/$(JVM_LOCALS)
	@echo "=== 测试jni程序运行完成 ==="

genjni: $(TARGET_FILE_JVM_LOCALS_JNI_HEADER)

# 清理生成的文件
clean:
	rm -f *.so *.class *.h *.log
	find . -name "*.class" -type f -delete
	@echo "=== 清理完成 ==="
