#!/bin/bash

# Test script for Static Site Server deployment

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

print_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((TESTS_PASSED++))
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Test 1: Check if required files exist
test_files_exist() {
    print_test "Checking if required files exist..."
    
    local files=(
        "docker-compose.yml"
        "nginx.conf"
        "site/index.html"
        "site/styles.css"
        "site/script.js"
        "site/images/demo.svg"
        "deploy.sh"
        "setup.sh"
    )
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            print_pass "File exists: $file"
        else
            print_fail "File missing: $file"
        fi
    done
}

# Test 2: Check Docker setup
test_docker_setup() {
    print_test "Checking Docker setup..."
    
    if command -v docker &> /dev/null; then
        print_pass "Docker is installed"
    else
        print_fail "Docker is not installed"
        return
    fi
    
    if command -v docker-compose &> /dev/null; then
        print_pass "Docker Compose is installed"
    else
        print_fail "Docker Compose is not installed"
        return
    fi
    
    # Check if containers are running
    if docker-compose ps | grep -q "Up"; then
        print_pass "Docker containers are running"
    else
        print_info "Docker containers are not running (this is OK if not started yet)"
    fi
}

# Test 3: Validate HTML structure
test_html_structure() {
    print_test "Validating HTML structure..."
    
    local html_file="site/index.html"
    
    if grep -q "<!DOCTYPE html>" "$html_file"; then
        print_pass "HTML has DOCTYPE declaration"
    else
        print_fail "HTML missing DOCTYPE declaration"
    fi
    
    if grep -q "<title>" "$html_file"; then
        print_pass "HTML has title tag"
    else
        print_fail "HTML missing title tag"
    fi
    
    if grep -q 'href="styles.css"' "$html_file"; then
        print_pass "HTML links to CSS file"
    else
        print_fail "HTML doesn't link to CSS file"
    fi
    
    if grep -q 'src="script.js"' "$html_file"; then
        print_pass "HTML links to JavaScript file"
    else
        print_fail "HTML doesn't link to JavaScript file"
    fi
    
    if grep -q 'src="images/demo.svg"' "$html_file"; then
        print_pass "HTML includes image"
    else
        print_fail "HTML doesn't include image"
    fi
}

# Test 4: Validate CSS
test_css_structure() {
    print_test "Validating CSS structure..."
    
    local css_file="site/styles.css"
    
    if grep -q "body {" "$css_file"; then
        print_pass "CSS has body styles"
    else
        print_fail "CSS missing body styles"
    fi
    
    if grep -q "@media" "$css_file"; then
        print_pass "CSS has responsive design"
    else
        print_fail "CSS missing responsive design"
    fi
    
    if grep -q "header" "$css_file"; then
        print_pass "CSS has header styles"
    else
        print_fail "CSS missing header styles"
    fi
}

# Test 5: Validate JavaScript
test_javascript() {
    print_test "Validating JavaScript..."
    
    local js_file="site/script.js"
    
    if grep -q "DOMContentLoaded" "$js_file"; then
        print_pass "JavaScript has DOM ready handler"
    else
        print_fail "JavaScript missing DOM ready handler"
    fi
    
    if grep -q "timestamp" "$js_file"; then
        print_pass "JavaScript updates timestamp"
    else
        print_fail "JavaScript doesn't update timestamp"
    fi
}

# Test 6: Validate deployment script
test_deployment_script() {
    print_test "Validating deployment script..."
    
    if [ -x "deploy.sh" ]; then
        print_pass "deploy.sh is executable"
    else
        print_fail "deploy.sh is not executable"
    fi
    
    if grep -q "rsync" "deploy.sh"; then
        print_pass "deploy.sh uses rsync"
    else
        print_fail "deploy.sh doesn't use rsync"
    fi
    
    if grep -q "ssh" "deploy.sh"; then
        print_pass "deploy.sh uses SSH"
    else
        print_fail "deploy.sh doesn't use SSH"
    fi
}

# Test 7: Validate Nginx configuration
test_nginx_config() {
    print_test "Validating Nginx configuration..."
    
    local nginx_file="nginx.conf"
    
    if grep -q "server {" "$nginx_file"; then
        print_pass "Nginx config has server block"
    else
        print_fail "Nginx config missing server block"
    fi
    
    if grep -q "listen.*80" "$nginx_file"; then
        print_pass "Nginx config listens on port 80"
    else
        print_fail "Nginx config doesn't listen on port 80"
    fi
    
    if grep -q "root.*html" "$nginx_file"; then
        print_pass "Nginx config has document root"
    else
        print_fail "Nginx config missing document root"
    fi
}

# Test 8: Test server connectivity (if running)
test_server_connectivity() {
    print_test "Testing server connectivity..."
    
    if docker-compose ps | grep -q "Up"; then
        # Test HTTP connection
        if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
            print_pass "HTTP server is responding"
        else
            print_fail "HTTP server is not responding"
        fi
        
        # Test SSH connection (with timeout)
        if timeout 5 nc -z localhost 2222 2>/dev/null; then
            print_pass "SSH port is accessible"
        else
            print_fail "SSH port is not accessible"
        fi
    else
        print_info "Containers not running - skipping connectivity tests"
    fi
}

# Test 9: Validate Docker Compose configuration
test_docker_compose() {
    print_test "Validating Docker Compose configuration..."
    
    if docker-compose config &>/dev/null; then
        print_pass "Docker Compose configuration is valid"
    else
        print_fail "Docker Compose configuration is invalid"
    fi
    
    if grep -q "nginx" "docker-compose.yml"; then
        print_pass "Docker Compose includes Nginx service"
    else
        print_fail "Docker Compose missing Nginx service"
    fi
    
    if grep -q "8080:80" "docker-compose.yml"; then
        print_pass "Docker Compose maps port 8080 to 80"
    else
        print_fail "Docker Compose doesn't map port 8080 to 80"
    fi
}

# Main test execution
main() {
    echo "========================================="
    echo "  Static Site Server Test Suite"
    echo "========================================="
    echo ""
    
    test_files_exist
    echo ""
    
    test_docker_setup
    echo ""
    
    test_html_structure
    echo ""
    
    test_css_structure
    echo ""
    
    test_javascript
    echo ""
    
    test_deployment_script
    echo ""
    
    test_nginx_config
    echo ""
    
    test_docker_compose
    echo ""
    
    test_server_connectivity
    echo ""
    
    # Summary
    echo "========================================="
    echo "  Test Results"
    echo "========================================="
    echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    echo ""
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed! ✓${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed! ✗${NC}"
        exit 1
    fi
}

# Handle command line arguments
case "${1:-all}" in
    "all")
        main
        ;;
    "files")
        test_files_exist
        ;;
    "docker")
        test_docker_setup
        ;;
    "html")
        test_html_structure
        ;;
    "css")
        test_css_structure
        ;;
    "js")
        test_javascript
        ;;
    "deploy")
        test_deployment_script
        ;;
    "nginx")
        test_nginx_config
        ;;
    "connectivity")
        test_server_connectivity
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [test]"
        echo ""
        echo "Tests:"
        echo "  all          Run all tests (default)"
        echo "  files        Test file existence"
        echo "  docker       Test Docker setup"
        echo "  html         Test HTML structure"
        echo "  css          Test CSS structure"
        echo "  js           Test JavaScript"
        echo "  deploy       Test deployment script"
        echo "  nginx        Test Nginx configuration"
        echo "  connectivity Test server connectivity"
        echo "  help         Show this help message"
        ;;
    *)
        echo "Unknown test: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac