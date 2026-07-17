import sys

def main():
    print("HellBoy AI Python Engine")

    if len(sys.argv) > 1:
        print("Command:", " ".join(sys.argv[1:]))

if __name__ == "__main__":
    main()