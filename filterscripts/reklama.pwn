#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 101 //�������� ������� �� ������� + 1 (���� 50 �������, �� ����� 51 !!!)

#if (MAX_PLAYERS > 501)
	#undef MAX_PLAYERS
	#define MAX_PLAYERS 501
#endif

forward Reklama1();
forward Reklama2();
new reklamatimer1;
new reklamatimer2;

public OnFilterScriptInit()
{
	reklamatimer1 = SetTimer("Reklama1",300000,1);
	reklamatimer2 = SetTimer("Reklama2",360000,1);
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(reklamatimer1);
	KillTimer(reklamatimer2);
	return 1;
}

public Reklama1()
{
	SendClientMessageToAll(0xFFFF00FF,"Russian_Drift: {FFFFFF}�� ���� ����� ����� ���� ���� �������.");
	SendClientMessageToAll(0xFFFF00FF,"Russian_Drift: {FFFFFF}�� ���� ����� ����� ���� ���� �������.");
	return 1;
}

public Reklama2()
{
	for(new i = 0; i <MAX_PLAYERS; i++)//���� ��� ���� �������
	{
		if(IsPlayerConnected(i))//���������� ��������� ���� ����� � ��������
		{
			if(GetPVarInt(i, "MnMode") == 1)
			{
				SendClientMessage(i,0xFFFF00FF,"Russian_Drift: {FFFFFF}������ �� �������� �������: {FFF82F}/help  {FFFFFF}������� ����: {FFF82F}����� Alt, ''2'' {FFFFFF}, ��� {FFF82F}/menu");
			}
			else
			{
				SendClientMessage(i,0xFFFF00FF,"Russian_Drift: {FFFFFF}������ �� �������� �������: {FFF82F}/help  {FFFFFF}������� ����: {FFF82F}Y {FFFFFF}��� {FFF82F}/menu");
			}
		}
	}
	return 1;
}

