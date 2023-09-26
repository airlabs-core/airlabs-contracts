import { Test, TestingModule } from '@nestjs/testing';
import { QuestService } from './quest.service';
import { ZeroAddress } from 'ethers';

describe('QuestService', () => {
  let service: QuestService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [QuestService],
    }).compile();

    service = module.get<QuestService>(QuestService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should mock real quest', async () => {
    const quest = {
      reveal_date: new Date(),
      experience_points: 5000,
      tokenId: 1,
      author: ZeroAddress,
      related_project: 'related_project',
      image_url: 'image_url',
      json_url: 'json_url',
      max_claimed: 0,
      name: 'name',
      requirements: [
        {
          chain_id: 1,
          title: 'check balance',
          contract_address: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
          abi: [
            'function balanceOf(address owner) view returns (uint256)',
            'event Transfer(address indexed from, address indexed to, uint amount)',
          ],
          callables: [
            {
              selector:
                'function balanceOf(address owner) view returns (uint256)',
              args: ['0x3E8c686F499C877D8f4aFB1215b6f0935796b986'],
            },
          ],
        },
      ],
    };
    console.log(quest);
  });
});
