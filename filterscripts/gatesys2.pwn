//==============================================================================
//                            �������� ���������
//==============================================================================

#define MOD77INS 1 //����� ���������� ��������:
//                 //MOD77INS 1 - ��������-������� (����� ��������� ����� ����� �� ������ ����� �����).
//                 //MOD77INS 2 - �������� /gate (����� ��������� ������ ����� �� ���������������
//                 //             �����, � �������� ������ ����� ����� �����).

//   �������� !!! ����� ��������� �������� ����������� ��������������� !!!
//==============================================================================
#if (MOD77INS < 1)
	#undef MOD77INS
	#define MOD77INS 1
#endif
#if (MOD77INS > 2)
	#undef MOD77INS
	#define MOD77INS 2
#endif

#include <a_samp>
#include <streamer>

#undef MAX_PLAYERS
#define MAX_PLAYERS 101 //�������� ������� �� ������� + 1 (���� 50 �������, �� ����� 51 !!!)

#if (MAX_PLAYERS > 501)
	#undef MAX_PLAYERS
	#define MAX_PLAYERS 501
#endif

#define MAX_GATE 2 //����� ����� �� ������� (����������� - ������ ���������� !!!) (2)
#define MAX_MOVE 3 //����� "������������" �������� (����������� - ������ ���������� !!!) (3)
#define G_SPEED 1.00 //�������� ����������� �����
/*
--------------------------------------------------------------------------------
������� �������� ����������� �������� � ������������:

����������� �������:
CreateObject(971, -250.89, 1510.65, 78.17,   0.00, 0.00, 180.00);
CreateObject(971, -269.57, 1510.95, 78.17,   0.00, 0.00, 0.00);
CreateObject(971, -278.45, 1510.98, 78.17,   0.00, 0.00, 0.00);

������������ �������:
CreateDynamicObject(971, -250.89, 1510.65, 78.17,   0.00, 0.00, 180.00, -1, -1, -1, 500);
CreateDynamicObject(971, -269.57, 1510.95, 78.17,   0.00, 0.00, 0.00, -1, -1, -1, 500);
CreateDynamicObject(971, -278.45, 1510.98, 78.17,   0.00, 0.00, 0.00, -1, -1, -1, 500);

����������� ������������ ��������:
MoveDynamicObject(idobject[0], -250.89, 1510.65, 81.67, G_SPEED, -90.00, 0.00, 180.00);
MoveDynamicObject(idobject[1], -269.57, 1510.95, 70.60, G_SPEED);//������ ����������� ������� ��� ��������� �� ���� X, Y, � Z
MoveDynamicObject(idobject[2], -278.45, 1510.98, 70.60, G_SPEED);//������ ����������� ������� ��� ��������� �� ���� X, Y, � Z

	idobject[0] - ID ������������� �������
	-250.89, 1510.65, 78.17 - ����������, � ������� ����� ����������� ������
	G_SPEED - �������� ����������� �������
	-90.00, 0.00, 180.00 - ���� ��������� �� ���� X, Y, � Z ��������������,
	�� ������� ����� ��������� ������������ ������

	�������� !!! ������ ������ ������������ �� streamer-�������� v2.7.2 !!!
	��� ������������� streamer-������� ����� ������ ������ - ��������
	��������������, ���� �������� ������� �� ���� X, Y, � Z � �������
	����������� ������������� ������� (MoveDynamicObject) !!!
	� ����� ������ ����������� MoveDynamicObject ��� ������� ����� ���������
	�� ���� X, Y, � Z... ������:

����������� ������������ �������� ��� ����� ������ ������ streamer-�������:
MoveDynamicObject(idobject[0], -240.38, 1510.78, 86.17, G_SPEED);
MoveDynamicObject(idobject[1], -269.57, 1510.95, 70.60, G_SPEED);
MoveDynamicObject(idobject[2], -278.45, 1510.98, 70.60, G_SPEED);

--------------------------------------------------------------------------------
*/
forward timobj();

new Text3D:fantxt;//���������� ��� �������� 3D-������ � ������������� ��
new statgate[MAX_GATE];
new idobject[MAX_MOVE];
new idgang[MAX_GATE];
new Float:CorX[MAX_GATE];
new Float:CorY[MAX_GATE];
new Float:CorZ[MAX_GATE];
new namegate[MAX_GATE][128];
new Text3D:GateLabel[MAX_GATE];

public OnFilterScriptInit()
{
	fantxt = Create3DTextLabel(" ",0xFFFFFFAA,0.000,0.000,-4.000,18.0,0,1);//������ 3D-����� � ������������� ��
	print(" ");
	print("-------------------------");
	print("    GateSys ���������");
	print("-------------------------\n");

	for(new i = 0; i < MAX_GATE; i++)//����������� ���� ������� ������ "�������"
	{
		statgate[i] = 0;
	}
	SetTimer("timobj", 300, 0);
	new string[256];

	CorX[0] = -250.89;//���������� 3D-������ �������� ����� ��� �����-1
	CorY[0] = 1511.65;
	CorZ[0] = 76.17;

	CorX[1] = -274.45;//���������� 3D-������ �������� ����� ��� �����-2
	CorY[1] = 1511.95;
	CorZ[1] = 76.17;

#if (MOD77INS == 1)//����� ���������� ��������-�������
	idgang[0] = -1;//��������� ���������� ID �����
	format(namegate[0], 128, "{FF0000}Drift-1");//�������� ����� ��� �����-1
	format(string, sizeof(string), "���� �����: %s", namegate[0]);
	GateLabel[0] = CreateDynamic3DTextLabel(string, 0x00FF00FF, CorX[0], CorY[0], CorZ[0], 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1);//����������� ������-1

	idgang[1] = -1;//��������� ���������� ID �����
	format(namegate[1], 128, "{FF0000}Drift-2");//�������� ����� ��� �����-2
	format(string, sizeof(string), "���� �����: %s", namegate[1]);
	GateLabel[1] = CreateDynamic3DTextLabel(string, 0x00FF00FF, CorX[1], CorY[1], CorZ[1], 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1);//����������� ������-2
#endif
#if (MOD77INS == 2)//����� ���������� �������� /gate
	idgang[0] = 1;//ID ����� ��� �����-1
	format(namegate[0], 128, "{FF0000}Drift-1");//�������� ����� ��� �����-1
	format(string, sizeof(string), "���� �����: %s\n{00FF00}���������� �������� - /gate", namegate[0]);
	GateLabel[0] = CreateDynamic3DTextLabel(string, 0x00FF00FF, CorX[0], CorY[0], CorZ[0], 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1);//����������� ������-1

	idgang[1] = 12;//ID ����� ��� �����-2
	format(namegate[1], 128, "{FF0000}Drift-2");//�������� ����� ��� �����-2
	format(string, sizeof(string), "���� �����: %s\n{00FF00}���������� �������� - /gate", namegate[1]);
	GateLabel[1] = CreateDynamic3DTextLabel(string, 0x00FF00FF, CorX[1], CorY[1], CorZ[1], 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1);//����������� ������-2
#endif
	return 1;
}

public timobj()
{

	idobject[0] = CreateDynamicObject(971, -250.89, 1510.65, 78.17,   0.00, 0.00, 180.00, -1, -1, -1, 500);//������-1 � �������� ���������

	idobject[1] = CreateDynamicObject(971, -269.57, 1510.95, 78.17,   0.00, 0.00, 0.00, -1, -1, -1, 500);//������-2 � �������� ���������
	idobject[2] = CreateDynamicObject(971, -278.45, 1510.98, 78.17,   0.00, 0.00, 0.00, -1, -1, -1, 500);

	return 1;
}

public OnFilterScriptExit()
{
	Delete3DTextLabel(fantxt);//������� 3D-����� � ������������� ��
 	for(new i = 0; i < MAX_MOVE; i++)
	{
		DestroyDynamicObject(idobject[i]);//������� ��� �������
	}
 	for(new i = 0; i < MAX_GATE; i++)
	{
		DestroyDynamic3DTextLabel(GateLabel[i]);//������� ��� ������� (3D-������)
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(GetPVarInt(playerid, "CComAc6") < 0)
	{
		new dopcis, sstr[256];
		dopcis = FCislit(GetPVarInt(playerid, "CComAc6"));
		switch(dopcis)
		{
			case 0: format(sstr, sizeof(sstr), " ���� � ���� (��� � ��������) !   ���������� ����� %d ������ !", GetPVarInt(playerid, "CComAc6") * -1);
			case 1: format(sstr, sizeof(sstr), " ���� � ���� (��� � ��������) !   ���������� ����� %d ������� !", GetPVarInt(playerid, "CComAc6") * -1);
			case 2: format(sstr, sizeof(sstr), " ���� � ���� (��� � ��������) !   ���������� ����� %d ������� !", GetPVarInt(playerid, "CComAc6") * -1);
		}
		SendClientMessage(playerid, 0xFF0000FF, sstr);
		return 1;
	}
	SetPVarInt(playerid, "CComAc6", GetPVarInt(playerid, "CComAc6") + 1);
	new string[256];
    new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname,sizeof(pname));
	new aa333[64];//��������� ��� ������������� ������� �����
	format(aa333, sizeof(aa333), "%s", pname);//��������� ��� ������������� ������� �����
#if (MOD77INS == 1)//����� ���������� ��������-�������
    if(!strcmp(cmdtext, "/gate1", true))//������� �������-������� ������-1 "/gate1"
    {
        if(statgate[0] == 0)//���������, ���� ������-1 �������
        {
			printf("[gatesys] %s [%d] ������ ������ ���� %s", aa333, playerid, namegate[0]);//������� ��������� � ��� ������� (��������� ��� ������������� ������� �����)
//			printf("[gatesys] %s [%d] ������ ������ ���� %s", pname, playerid, namegate[0]);//������� ��������� � ��� �������
			format(string, sizeof(string), "�� ������� ������ ���� %s", namegate[0]);
			SendClientMessage(playerid, 0x00FF00FF, string);
			UpdateDynamic3DTextLabelText(GateLabel[0], 0xFFFFFFFF, " ");//������� ������� � �����-1
			MoveDynamicObject(idobject[0], -250.89, 1510.65, 81.67, G_SPEED, -90.00, 0.00, 180.00);//����������� ������� ������-1
			statgate[0] = 1;//�������� ������ �� "�������"
        }
        else//���������, ���� ������-1 �������
        {
			printf("[gatesys] %s [%d] ������ ������ ���� %s", aa333, playerid, namegate[0]);//������� ��������� � ��� ������� (��������� ��� ������������� ������� �����)
//			printf("[gatesys] %s [%d] ������ ������ ���� %s", pname, playerid, namegate[0]);//������� ��������� � ��� �������
			format(string, sizeof(string), "�� ������� ������ ���� %s", namegate[0]);
			SendClientMessage(playerid, 0xFF0000FF, string);
			format(string, sizeof(string), "���� �����: %s", namegate[0]);
			UpdateDynamic3DTextLabelText(GateLabel[0], 0x00FF00FF, string);//����������� ������-1
			MoveDynamicObject(idobject[0], -250.89, 1510.65, 78.17, G_SPEED, 0.00, 0.00, 180.00);//����������� ������� ������-1 � ���������� ��������
			statgate[0] = 0;//�������� ������ �� "�������"
        }
        return 1;
	}
    if(!strcmp(cmdtext, "/gate2", true))//������� �������-������� ������-2 "/gate2"
    {
        if(statgate[1] == 0)//���������, ���� ������-2 �������
        {
			printf("[gatesys] %s [%d] ������ ������ ���� %s", aa333, playerid, namegate[1]);//������� ��������� � ��� ������� (��������� ��� ������������� ������� �����)
//			printf("[gatesys] %s [%d] ������ ������ ���� %s", pname, playerid, namegate[1]);//������� ��������� � ��� �������
			format(string, sizeof(string), "�� ������� ������ ���� %s", namegate[1]);
			SendClientMessage(playerid, 0x00FF00FF, string);
			UpdateDynamic3DTextLabelText(GateLabel[1], 0xFFFFFFFF, " ");//������� ������� � �����-2
			MoveDynamicObject(idobject[1], -269.57, 1510.95, 70.60, G_SPEED);//����������� ������� ������-2
			MoveDynamicObject(idobject[2], -278.45, 1510.98, 70.60, G_SPEED);
			statgate[1] = 1;//�������� ������ �� "�������"
        }
        else//���������, ���� ������-2 �������
        {
			printf("[gatesys] %s [%d] ������ ������ ���� %s", aa333, playerid, namegate[1]);//������� ��������� � ��� ������� (��������� ��� ������������� ������� �����)
//			printf("[gatesys] %s [%d] ������ ������ ���� %s", pname, playerid, namegate[1]);//������� ��������� � ��� �������
			format(string, sizeof(string), "�� ������� ������ ���� %s", namegate[1]);
			SendClientMessage(playerid, 0xFF0000FF, string);
			format(string, sizeof(string), "���� �����: %s", namegate[1]);
			UpdateDynamic3DTextLabelText(GateLabel[1], 0x00FF00FF, string);//����������� ������-2
			MoveDynamicObject(idobject[1], -269.57, 1510.95, 78.17, G_SPEED);//����������� ������� ������-2 � ���������� ��������
			MoveDynamicObject(idobject[2], -278.45, 1510.98, 78.17, G_SPEED);
			statgate[1] = 0;//�������� ������ �� "�������"
        }
        return 1;
	}
#endif
#if (MOD77INS == 2)//����� ���������� �������� /gate
    if(!strcmp(cmdtext, "/gate", true))//������� /gate
    {
		new per1 = 0;
		new per2 = -600;
		while(per1 < MAX_GATE)
		{
//			if(GetPVarInt(playerid, "PlGng") == idgang[per1] &&
//			IsPlayerInRangeOfPoint(playerid, 15.0, CorX[per1], CorY[per1], CorZ[per1]))//���������� �������� ������ �������� �� �����
			if((GetPVarInt(playerid, "PlGng") == idgang[per1] || IsPlayerAdmin(playerid)) &&
			IsPlayerInRangeOfPoint(playerid, 15.0, CorX[per1], CorY[per1], CorZ[per1]))//���������� �������� �������� �� ����� � RCON-�������
        	{
				per2 = per1;
				break;
			}
			per1++;
		}
        if(per2 == -600)
        {
			SendClientMessage(playerid, 0xFF0000FF, "��� �� ���� ������, ��� ������ ������� ������ !");
			return 1;
        }
		if(statgate[per2] == 0)//���� ������ �������, ��:
		{
			if(GetPVarInt(playerid, "PlGng") != idgang[per2] && IsPlayerAdmin(playerid))
			{
				printf("[gatesys] RCON %s [%d] ������ ������ ���� %s", aa333, playerid, namegate[per2]);//������� ��������� � ��� ������� (��������� ��� ������������� ������� �����)
//				printf("[gatesys] %s [%d] ������ ������ ���� %s", pname, playerid, namegate[per2]);//������� ��������� � ��� �������
			}
			else
			{
				printf("[gatesys] %s [%d] ������ ������ ���� %s", aa333, playerid, namegate[per2]);//������� ��������� � ��� ������� (��������� ��� ������������� ������� �����)
//				printf("[gatesys] %s [%d] ������ ������ ���� %s", pname, playerid, namegate[per2]);//������� ��������� � ��� �������
			}
		}
		else//�����:
		{
			if(GetPVarInt(playerid, "PlGng") != idgang[per2] && IsPlayerAdmin(playerid))
			{
				printf("[gatesys] RCON %s [%d] ������ ������ ���� %s", aa333, playerid, namegate[per2]);//������� ��������� � ��� ������� (��������� ��� ������������� ������� �����)
//				printf("[gatesys] %s [%d] ������ ������ ���� %s", pname, playerid, namegate[per2]);//������� ��������� � ��� �������
			}
			else
			{
				printf("[gatesys] %s [%d] ������ ������ ���� %s", aa333, playerid, namegate[per2]);//������� ��������� � ��� ������� (��������� ��� ������������� ������� �����)
//				printf("[gatesys] %s [%d] ������ ������ ���� %s", pname, playerid, namegate[per2]);//������� ��������� � ��� �������
			}
		}
		if(per2 == 0)//���������� ��������-1
        {
        	if(statgate[0] == 0)//���������, ���� ������-1 �������
        	{
				format(string, sizeof(string), "�� ������� ������ ���� %s", namegate[0]);
				SendClientMessage(playerid, 0x00FF00FF, string);
				UpdateDynamic3DTextLabelText(GateLabel[0], 0xFFFFFFFF, " ");//������� ������� � �����-1
				MoveDynamicObject(idobject[0], -250.89, 1510.65, 81.67, G_SPEED, -90.00, 0.00, 180.00);//����������� ������� ������-1
				statgate[0] = 1;//�������� ������ �� "�������"
        	}
        	else//���������, ���� ������-1 �������
        	{
				format(string, sizeof(string), "�� ������� ������ ���� %s", namegate[0]);
				SendClientMessage(playerid, 0xFF0000FF, string);
				format(string, sizeof(string), "���� �����: %s\n{00FF00}���������� �������� - /gate", namegate[0]);
				UpdateDynamic3DTextLabelText(GateLabel[0], 0x00FF00FF, string);//����������� ������-1
				MoveDynamicObject(idobject[0], -250.89, 1510.65, 78.17, G_SPEED, 0.00, 0.00, 180.00);//����������� ������� ������-1 � ���������� ��������
				statgate[0] = 0;//�������� ������ �� "�������"
        	}
        	return 1;
		}
    	if(per2 == 1)//���������� ��������-2
    	{
        	if(statgate[1] == 0)//���������, ���� ������-2 �������
        	{
				format(string, sizeof(string), "�� ������� ������ ���� %s", namegate[1]);
				SendClientMessage(playerid, 0x00FF00FF, string);
				UpdateDynamic3DTextLabelText(GateLabel[1], 0xFFFFFFFF, " ");//������� ������� � �����-2
				MoveDynamicObject(idobject[1], -269.57, 1510.95, 70.60, G_SPEED);//����������� ������� ������-2
				MoveDynamicObject(idobject[2], -278.45, 1510.98, 70.60, G_SPEED);
				statgate[1] = 1;//�������� ������ �� "�������"
        	}
        	else//���������, ���� ������-2 �������
        	{
				format(string, sizeof(string), "�� ������� ������ ���� %s", namegate[1]);
				SendClientMessage(playerid, 0xFF0000FF, string);
				format(string, sizeof(string), "���� �����: %s\n{00FF00}���������� �������� - /gate", namegate[1]);
				UpdateDynamic3DTextLabelText(GateLabel[1], 0x00FF00FF, string);//����������� ������-2
				MoveDynamicObject(idobject[1], -269.57, 1510.95, 78.17, G_SPEED);//����������� ������� ������-2 � ���������� ��������
				MoveDynamicObject(idobject[2], -278.45, 1510.98, 78.17, G_SPEED);
				statgate[1] = 0;//�������� ������ �� "�������"
        	}
        	return 1;
		}
    }
#endif
	return 0;
}

forward FCislit(cislo);
public FCislit(cislo)
{
	new para, para22, string[256], string22[4], string33[4];
	strdel(string22, 0, 4);
	strdel(string33, 0, 4);
	format(string, sizeof(string), "%d", cislo);
	para22 = strlen(string);
	if(para22 == 1)
	{
		strmid(string22, string, para22-1, para22, sizeof(string22));
	}
	else
	{
	    strmid(string22, string, para22-1, para22, sizeof(string22));
	    strmid(string33, string, para22-2, para22-1, sizeof(string33));
	}
	para22 = strval(string33);
	if(para22 > 1) { para22 = 0; }
	para22 = para22 * 10 + strval(string22);
	switch(para22)
	{
		case 0,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19: para = 0;
		case 1: para = 1;
		case 2,3,4: para = 2;
	}
	return para;
}

