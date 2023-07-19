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
      requirements: [{ title: 'Must hold at least 10 $ETH' }],
    };
    console.log(quest);
  });
});
