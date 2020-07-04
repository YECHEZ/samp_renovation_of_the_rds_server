//==============================================================================
//          ��� ���������� � ������� ���� ������ ��������� �������
//                   �������������� �������� (�������)

// �������� !!! �������������� ������� (�������) ����� ��������� ������
// � ������ ������� ������� ���� ������ !!!

// ���� ������ ������ ���� ����������� � �������� scriptfiles\.
// ��� ����� �������� ���� ������ (��� ���� (����������) �����) �����
// ������ � ������ 34. ������ ���� ���� ������: scriptfiles\players1.db
// ���������� �� ���������� �������� (�������) ������� � ������������ ����.

//==============================================================================

#include <a_samp>

#pragma dynamic 30000

new DB:playerdb;//���������� ���� ������ ��������� �������
new DBResult:querydb;//���������� �������� ���� ������ ��������� �������
new Name[32];//��� ����� �� (� �������� scriptfiles)

main()
{
	print(" ");
	print("\n------------------------------------------------");
	print(" ��� ���������� � ������� ���� ������ ���������   ");
	print("   ������� �������������� �������� (�������)      ");
	print("------------------------------------------------\n");
}

public OnGameModeInit()
{
	Name = "players1";//��� ����� �� (� �������� scriptfiles)
	SetTimer("Begin", 500, 0);
	return 1;
}

public OnGameModeExit()
{
	db_close(playerdb);//��������� �� �� �������
	return 1;
}

forward Begin();
public Begin()
{
	new string[256];
	format(string, sizeof(string), "%s.db", Name);
	if(!fexist(string))
	{
		print(" ");
		print(" ������ ! ���� ������ �� ���������� !");
		return 1;
	}
	else
	{
		print(" ���������� ���� ������.");
		SetTimer("Portation", 500, 0);
	}
	return 1;
}

forward Portation();
public Portation()
{
	new string[256];
	format(string, sizeof(string), "%s.db", Name);
	playerdb = db_open(string);//���������� �� � �������

	format(string, sizeof(string), "ALTER TABLE Players ADD COLUMN Data1 INTEGER");//������ ������ ��
	//�� ���������� ������ ������� ������ ���� � ������ Data1
	querydb = db_query(playerdb, string);//���������� ������ ��
	db_free_result(querydb);//������� ��������� ������� ��
	format(string, sizeof(string), "UPDATE Players SET Data1 = 10");//������ ������ ��
	//�� ���������� ����� ������ ������� � ������ Data1 ����� ������ 10
	querydb = db_query(playerdb, string);//���������� ������ ��
	db_free_result(querydb);//������� ��������� ������� ��

	format(string, sizeof(string), "ALTER TABLE Players ADD COLUMN Data2 FLOAT");//������ ������ ��
	//�� ���������� ������ ������� ������������� ���� � ������ Data2
	querydb = db_query(playerdb, string);//���������� ������ ��
	db_free_result(querydb);//������� ��������� ������� ��
	format(string, sizeof(string), "UPDATE Players SET Data2 = 100.378");//������ ������ ��
	//�� ���������� ����� ������ ������� � ������ Data2 ������������ ������ 100.378
	querydb = db_query(playerdb, string);//���������� ������ ��
	db_free_result(querydb);//������� ��������� ������� ��

	format(string, sizeof(string), "ALTER TABLE Players ADD COLUMN Data3 VARCHAR(32)");//������ ������ ��
	//�� ���������� ������ ������� ���������� ���� � ������ Data3
	querydb = db_query(playerdb, string);//���������� ������ ��
	db_free_result(querydb);//������� ��������� ������� ��
	format(string, sizeof(string), "UPDATE Players SET Data3 = 'free'");//������ ������ ��
	//�� ���������� ����� ������ ������� � ������ Data3 ������� "free"
	//���� ���������� ��������� ������� Data3 "�������" ��������, �� �����
	//��������� ������ ��: "UPDATE Players SET Data3 = ''"
	querydb = db_query(playerdb, string);//���������� ������ ��
	db_free_result(querydb);//������� ��������� ������� ��

	print(" ");
	print(" ��� ������� (�������) ���� ��������� � �� !");
	print(" ����� ��������� (�������) ���.");
	print(" ");
	db_close(playerdb);//��������� �� �� �������
	return 1;
}

