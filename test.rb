require 'prime'

#this file is just random activity checking resources and counting by prime to give the system some work to do

# Function to get system stats
def get_system_stats
  if RUBY_PLATFORM.include?('darwin')
    # macOS commands
    total_mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024

    top_output = `top -l 1 -n 0`
    free_mem = top_output[/PhysMem:.*?(\d+)M unused/, 1].to_i

    used_mem = total_mem - free_mem

    cpu_info = `ps -A -o %cpu | awk '{s+=$1} END {print s}'`.strip.to_f
    cpu_usage = cpu_info / `sysctl -n hw.ncpu`.to_i

    disk_info = `df -h / | grep /`.split
    total_disk = disk_info[1]
    used_disk = disk_info[2]
    available_disk = disk_info[3]

    { total_mem: total_mem, used_mem: used_mem, free_mem: free_mem, cpu_usage: cpu_usage, total_disk: total_disk, used_disk: used_disk, available_disk: available_disk }
  else
    # Ubuntu commands
    mem_info = `free -m | grep Mem`.split
    total_mem = mem_info[1].to_i
    used_mem = mem_info[2].to_i
    free_mem = mem_info[3].to_i

    cpu_info = `top -bn1 | grep "Cpu(s)"`.split
    cpu_usage = cpu_info[1].to_f

    disk_info = `df -h / | grep /`.split
    total_disk = disk_info[1]
    used_disk = disk_info[2]
    available_disk = disk_info[3]

    { total_mem: total_mem, used_mem: used_mem, free_mem: free_mem, cpu_usage: cpu_usage, total_disk: total_disk, used_disk: used_disk, available_disk: available_disk }
  end
end

# Function to print system stats
def print_system_stats(stats)
  puts "Memory: Total: #{stats[:total_mem]}MB, Used: #{stats[:used_mem]}MB, Free: #{stats[:free_mem]}MB"
  puts "CPU Usage: #{stats[:cpu_usage]}%"
  puts "Disk: Total: #{stats[:total_disk]}, Used: #{stats[:used_disk]}, Available: #{stats[:available_disk]}"
end

# Count to 1 million by prime numbers
Prime.each(100) do |prime|
  stats = get_system_stats
  print_system_stats(stats)
  puts "Current Prime: #{prime}"
end