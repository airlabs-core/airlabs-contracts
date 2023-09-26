import { Test, TestingModule } from '@nestjs/testing';
import { QuestRequirementController } from './quest-requirement.controller';
import { QuestRequirementService } from './quest-requirement.service';

describe('QuestRequirementController', () => {
  let controller: QuestRequirementController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [QuestRequirementController],
      providers: [QuestRequirementService],
    }).compile();

    controller = module.get<QuestRequirementController>(
      QuestRequirementController,
    );
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
