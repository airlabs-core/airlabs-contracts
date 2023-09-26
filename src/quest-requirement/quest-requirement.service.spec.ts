import { Test, TestingModule } from '@nestjs/testing';
import { QuestRequirementService } from './quest-requirement.service';

describe('QuestRequirementService', () => {
  let service: QuestRequirementService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [QuestRequirementService],
    }).compile();

    service = module.get<QuestRequirementService>(QuestRequirementService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
