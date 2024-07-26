fsNode fsRead(char* path);

enum class fsNodeType
{
	error,
	file,
	directory
}

class fsNode {
public:
	fsNodeType type;
}

int main()
{
	fsNode node = fsRead("/path/to/file");
	if(node.type == fsNodeType::file) {
		// handle file
	}
	else if(node.type == fsNodeType::directory) {
		// handle directory
	}
	else if(node.type == fsNodeType::error) {
		// handle error
	}
}